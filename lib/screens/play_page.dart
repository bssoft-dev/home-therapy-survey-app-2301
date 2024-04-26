import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_therapy_survey_app/model/play_number_model.dart';
import 'package:home_therapy_survey_app/utils/main_color.dart';
import 'package:home_therapy_survey_app/utils/stopwatch.dart';
import 'package:home_therapy_survey_app/utils/track_play_api.dart';
import 'package:home_therapy_survey_app/widgets/background_container_widget.dart';
import 'package:home_therapy_survey_app/widgets/custom_button_widget.dart';
import 'package:home_therapy_survey_app/widgets/track_player_widget.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class PlayMusic extends StatefulWidget {
  final int playCount;
  const PlayMusic({
    super.key,
    required this.playCount,
  });

  @override
  State<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  final stopwatchUtil = StopwatchUtil();
  late Duration _displayedTime;

  void _stopStopwatch() {
    stopwatchUtil.stopStopwatch();
    _displayedTime = stopwatchUtil.elapsedTime;
  }

  @override
  void initState() {
    super.initState();
    stopwatchUtil.startStopwatch();
  }

  @override
  void dispose() {
    stopwatchUtil.stopStopwatch(); // Ensure proper cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PlayNumberProvider provider = Provider.of<PlayNumberProvider>(context);
    int groupNumber = provider.groupNumber;
    int index = widget.playCount - 1;
    List<dynamic> playList = provider.playList;
    List<int> session1PlayList = provider.session1PlayList;
    String fileName = '${session1PlayList[index]}.wav';
    int playItemIndex = playList.indexOf(fileName);
    List<bool> playListIndex = provider.playListIndex;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          foregroundColor: const Color(0xff5A5A5A),
          actions: [
            simpleIconButton(
                Icons.settings_rounded, 40, const Color(0xff5A5A5A), () {
              Get.toNamed('setting');
            }),
          ],
        ),
        body: backgroundContainer(
          context: context,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(children: [
                  Text(
                    '그룹 $groupNumber - 세션 1',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Color(0xff5a5a5a),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: playIconButton(
                        Icons.play_circle_outline_rounded,
                        Icons.pause_circle_outline_rounded,
                        MediaQuery.of(context).size.width * 0.5,
                        playListIndex[playItemIndex],
                        () async {
                          // 음원 재생
                          bool hasTrueValue = playListIndex.contains(true);

                          if (hasTrueValue) {
                            // true인 항목이 있다면, 현재 재생 중인 트랙을 찾습니다.
                            int playingTrackIndex = playListIndex.indexOf(true);

                            if (playingTrackIndex == playItemIndex) {
                              // 선택한 트랙이 이미 재생 중인 트랙이면 정지합니다.
                              provider.updatePlayListIndex(
                                  playingTrackIndex, false);

                              await playStop();
                              endTime = DateTime.now();
                              await calculateElapsedTime(
                                      playTrackTitleTime.last['time']!,
                                      endTime!)
                                  .then((playingTime) {
                                playTrackTitleTime.last = ({
                                  "name": playList[playingTrackIndex],
                                  "time": playingTime,
                                });
                              });
                            } else {
                              // 선택한 트랙이 다른 트랙이면 현재 재생 중인 트랙 중지하고 선택한 트랙 재생
                              provider.updatePlayListIndex(playingTrackIndex,
                                  false); // 현재 재생 중인 트랙을 중지합니다.
                              provider.updatePlayListIndex(
                                  playItemIndex, true); // 선택한 트랙을 재생 상태로 설정합니다.
                              await playStop();
                              endTime = DateTime.now();
                              await calculateElapsedTime(
                                      playTrackTitleTime.last['time']!,
                                      endTime!)
                                  .then((playingTime) {
                                playTrackTitleTime.last = ({
                                  "name": playList[playingTrackIndex],
                                  "time": playingTime,
                                });
                              });
                              await trackPlay('ready', playList[playItemIndex]);
                              startTime = DateTime.now();
                              playTrackTitleTime.add({
                                "name": playList[playItemIndex],
                                "time": startTime,
                              });
                            }
                          } else {
                            // true인 항목이 없다면, 선택한 트랙을 재생
                            provider.updatePlayListIndex(
                                playItemIndex, true); // 선택한 트랙을 재생 상태로 설정합니다.
                            await trackPlay('ready', playList[playItemIndex]);
                            startTime = DateTime.now();
                            playTrackTitleTime.add(
                              {
                                "name": playList[playItemIndex],
                                "time": startTime,
                              },
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '음원 ${playList[playItemIndex]}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color(0xff5a5a5a),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final int totalNumber = provider.totalNumber;
                        provider.setPlayNumber(widget.playCount + 1);
                        final int playNumber = provider.playNumber;
                        _stopStopwatch();
                        provider.addSession1Result(
                            playList[playItemIndex], _displayedTime);
                        if (widget.playCount < totalNumber) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayMusic(
                                playCount: playNumber,
                              ),
                            ),
                          );
                        } else {
                          Get.toNamed('rest');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MainColor().mainColor().withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 20),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
