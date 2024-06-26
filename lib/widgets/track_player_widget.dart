import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:home_therapy_survey_app/widgets/noti_snackbar_widget.dart';
import 'package:home_therapy_survey_app/widgets/track_mixing_slider.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_therapy_survey_app/utils/share_rreferences_future.dart';
import 'package:home_therapy_survey_app/widgets/custom_button_widget.dart';
import 'package:home_therapy_survey_app/utils/track_play_api.dart';

List<String> ipv4Addresses = [];
List<String> filteredAddresses = [];
late List<String> trackPlayList;
late List<bool> trackPlayIndex;
String? trackTitle;
String firstMixingTrack = '';
String secondMixingTrack = '';
List<Map<String, dynamic>> playTrackTitleTime = [];
DateTime? startTime;
DateTime? endTime;
List<int> playingTime = [];

// 현재 true인 index 추적
int? currentlyPlayingIndex;

Future<bool> asyncTrackPlayListMethod() async {
  await getIpAddress();
  bool isDeviceConnected = await checkDeviceConnected();
  if (isDeviceConnected == true) {
    var response = await playList();
    trackPlayList = jsonDecode(utf8.decode(response.bodyBytes)).cast<String>();

    await initTrackTitle(trackPlayList);
    trackPlayIndex = List<bool>.generate(
        trackPlayList.length, (int index) => false,
        growable: true);
    if (response == 503) {
      return false;
    }
  }
  return isDeviceConnected;
}

Future<void> initTrackTitle(trackPlayList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedTrackTitle = prefs.getString('selected_track');
  trackTitle = savedTrackTitle ?? trackPlayList[0].split('.wav')[0];
}

Future<void> getIpAddress() async {
  ipv4Addresses.clear();
  await NetworkInterface.list().then((interfaces) {
    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          String ipAddress = address.address;
          debugPrint('IP address: $ipAddress');
          int dotIndex = ipAddress.lastIndexOf('.');
          if (dotIndex != -1) {
            ipv4Addresses.add(ipAddress.substring(0, dotIndex));
          } else {
            ipv4Addresses.add(ipAddress);
          }
          // 두번째 값이 0이 아닌값을 필터링합니다.
          filteredAddresses = ipv4Addresses.where((address) {
            final parts = address.split(".");

            if (parts.length < 3) return false; // IPv4 주소가 네 부분으로 나뉘어야 합니다.
            final twoPart = int.tryParse(parts[1]); // 두 번째 부분을 정수로 파싱
            return twoPart != null && twoPart != 0;
          }).toList();
        }
      }
    }
    debugPrint('$filteredAddresses');
  });
}

Future playTrack({
  required BuildContext context,
  required String trackTitle,
  required String actionText,
  required Future Function(List<Map<String, dynamic>> playTrackTitle) tracks,
  Widget? volumeSlider,
}) {
  return Get.dialog(barrierDismissible: false, name: '음원재생',
      StatefulBuilder(builder: ((context, StateSetter setDialog) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 40),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: mainColor.mainColor(),
                    ),
                    child: Lottie.asset('assets/lottie/track_list.json',
                        width: 40, height: 40, fit: BoxFit.fill, animate: true),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    trackTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
                child: trackList(setDialog: setDialog, context: context)),
          ],
        ),
      ),
      actions: <Widget>[
        volumeSlider ?? const SizedBox(height: 0),
        TextButton(
          child: Text(actionText, style: const TextStyle(fontSize: 20)),
          onPressed: () async {
            if (playTrackTitleTime.isNotEmpty) {
              await tracks(playTrackTitleTime);
            } else {
              failSnackBar('오류', '음원을 선택해 재생시켜주세요.');
            }
          },
        ),
      ],
    );
  })));
}

Future prePlayTrack({
  required BuildContext context,
  required String trackTitle,
  required String actionText,
  Widget? volumeSlider,
}) {
  return Get.dialog(barrierDismissible: false, name: '음원재생',
      StatefulBuilder(builder: ((context, StateSetter setDialog) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 40),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: mainColor.mainColor(),
                    ),
                    child: Lottie.asset('assets/lottie/track_list.json',
                        width: 40, height: 40, fit: BoxFit.fill, animate: true),
                  ),
                  const SizedBox(width: 10),
                  Text(trackTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
                child: trackList(setDialog: setDialog, context: context)),
          ],
        ),
      ),
      actions: <Widget>[
        volumeSlider ?? const SizedBox(height: 0),
        TextButton(
          child: Text(actionText, style: const TextStyle(fontSize: 20)),
          onPressed: () async {
            Get.back();
            await playStop();
          },
        ),
      ],
    );
  })));
}

Widget trackList({
  required StateSetter setDialog,
  required BuildContext context,
}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: trackPlayList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: trackPlayIndex[index]
                  ? mainColor.mainColor().withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 20),
                  child: Lottie.asset('assets/lottie/sound_play.json',
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      animate: trackPlayIndex[index]),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          trackPlayList[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: playIconButton(
                              Icons.play_arrow_rounded,
                              Icons.pause_circle_outline_rounded,
                              40,
                              trackPlayIndex[index], () async {
                            bool hasTrueValue = trackPlayIndex.contains(true);
                            if (hasTrueValue) {
                              // true인 항목이 있다면, 현재 재생 중인 트랙을 찾습니다.
                              int playingTrackIndex =
                                  trackPlayIndex.indexOf(true);

                              if (playingTrackIndex == index) {
                                // 선택한 트랙이 이미 재생 중인 트랙이면 정지합니다.
                                setDialog(() {
                                  trackPlayIndex[playingTrackIndex] =
                                      false; // 현재 재생 중인 트랙을 중지합니다.
                                });
                                await playStop();
                                endTime = DateTime.now();
                                await calculateElapsedTime(
                                        playTrackTitleTime.last['time']!,
                                        endTime!)
                                    .then((playingTime) {
                                  playTrackTitleTime.last = ({
                                    "name": trackPlayList[playingTrackIndex],
                                    "time": playingTime,
                                  });
                                });
                              } else {
                                // 선택한 트랙이 다른 트랙이면 현재 재생 중인 트랙 중지하고 선택한 트랙 재생
                                setDialog(() {
                                  trackPlayIndex[playingTrackIndex] =
                                      false; // 현재 재생 중인 트랙을 중지합니다.
                                  trackPlayIndex[index] =
                                      true; // 선택한 트랙을 재생 상태로 설정합니다.
                                });
                                await playStop();
                                endTime = DateTime.now();
                                await calculateElapsedTime(
                                        playTrackTitleTime.last['time']!,
                                        endTime!)
                                    .then((playingTime) {
                                  playTrackTitleTime.last = ({
                                    "name": trackPlayList[playingTrackIndex],
                                    "time": playingTime,
                                  });
                                });
                                await trackPlay('ready', trackPlayList[index]);
                                startTime = DateTime.now();
                                playTrackTitleTime.add({
                                  "name": trackPlayList[index],
                                  "time": startTime,
                                });
                              }
                            } else {
                              // true인 항목이 없다면, 선택한 트랙을 재생
                              setDialog(() {
                                trackPlayIndex[index] =
                                    true; // 선택한 트랙을 재생 상태로 설정합니다.
                              });
                              await trackPlay('ready', trackPlayList[index]);
                              startTime = DateTime.now();
                              playTrackTitleTime.add({
                                "name": trackPlayList[index],
                                "time": startTime,
                              });
                            }
                          })),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
  );
}

Future<int> calculateElapsedTime(DateTime startTime, DateTime endTime) async {
  Duration elapsedDuration = endTime.difference(startTime);
  return elapsedDuration.inSeconds;
}

Widget mixTrackList({required List containerColors}) {
  return StatefulBuilder(builder: (context, StateSetter setState) {
    return Stack(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trackPlayList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        containerColors[index] = !containerColors[index];
                        debugPrint('${containerColors[index]}');
                        int bottmSheetCount = containerColors
                            .where((element) => element == true)
                            .length;
                        if (bottmSheetCount >= 2) {
                          List<String> selectedTracks = [];
                          for (int i = 0; i < trackPlayList.length; i++) {
                            if (containerColors[i]) {
                              selectedTracks.add(trackPlayList[i]);
                            }
                          }
                          // if (selectedTracks.length >= 2) {
                          showModalBottomSheet(
                              clipBehavior: Clip.antiAlias,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: TrackMixingSlider(
                                        trackSelectOne: selectedTracks[0],
                                        trackSelectTwo: selectedTracks[1]),
                                  ),
                                );
                              });
                          // }
                        }
                      });
                    },
                    child: Container(
                      color: containerColors[index]
                          ? mainColor.mainColor().withOpacity(0.1)
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                trackPlayList[index],
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                  containerColors[index]
                                      ? Icons.check_circle_rounded
                                      : Icons.check_circle_outline_rounded,
                                  color: containerColors[index]
                                      ? mainColor.mainColor()
                                      : const Color(0xff5a5a5a)),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: playIconButton(
                                    Icons.play_arrow_rounded,
                                    Icons.pause_circle_outline_rounded,
                                    40,
                                    trackPlayIndex[index], () async {
                                  setState(() {
                                    trackPlayIndex[index] =
                                        !trackPlayIndex[index];
                                  });
                                  if (trackPlayIndex[index]) {
                                    await trackPlay(
                                        'ready', trackPlayList[index]);
                                  } else {
                                    await playStop();
                                  }
                                }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 0,
                  ),
                ],
              );
            }),
      ],
    );
  });
}
