import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:home_therapy_app/model/play_number_model.dart';
import 'package:home_therapy_app/utils/track_play_api.dart';
import 'package:home_therapy_app/widgets/background_container_widget.dart';
import 'package:home_therapy_app/widgets/custom_button_widget.dart';
import 'package:home_therapy_app/widgets/track_player_widget.dart';
import 'package:provider/provider.dart';

class PlayTouchPosition extends StatefulWidget {
  final int playCount;
  const PlayTouchPosition({super.key, required this.playCount});

  @override
  _PlayTouchPositionState createState() => _PlayTouchPositionState();
}

class _PlayTouchPositionState extends State<PlayTouchPosition> {
  // 원형 위젯의 위치를 저장할 변수
  Offset? circlePosition;
  // 터치 위치를 저장할 변수
  String _position = '여기를 터치하세요';

  @override
  Widget build(BuildContext context) {
    PlayNumberProvider provider = Provider.of<PlayNumberProvider>(context);
    int groupNumber = provider.groupNumber;
    int index = widget.playCount - 1;
    List<String> playList = provider.playList;
    List<bool> playListIndex = provider.playListIndex;
    // 위젯의 너비와 높이를 정의합니다.
    final screenWidth = MediaQuery.of(context).size.width;
    final widgetSize = screenWidth * 0.7; //  화면 너비의 80%
    final containerSize = screenWidth * 0.83; //  화면 너비의 80%

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        foregroundColor: const Color(0xff5A5A5A),
        actions: [
          simpleIconButton(Icons.settings_rounded, 40, const Color(0xff5A5A5A),
              () {
            Get.toNamed('setting');
          }),
        ],
      ),
      body: backgroundContainer(
        context: context,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                      MediaQuery.of(context).size.width * 0.2,
                      playListIndex[index],
                      () async {
                        // 시간 계산
                        if (widget.playCount == 1 &&
                            playListIndex[index] == false) {}
                        // 음원 재생
                        bool hasTrueValue = playListIndex.contains(true);

                        if (hasTrueValue) {
                          // true인 항목이 있다면, 현재 재생 중인 트랙을 찾습니다.
                          int playingTrackIndex = playListIndex.indexOf(true);

                          if (playingTrackIndex == index) {
                            // 선택한 트랙이 이미 재생 중인 트랙이면 정지합니다.
                            provider.updatePlayListIndex(
                                playingTrackIndex, false);

                            await playStop();
                            endTime = DateTime.now();
                            await calculateElapsedTime(
                                    playTrackTitleTime.last['time']!, endTime!)
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
                                index, true); // 선택한 트랙을 재생 상태로 설정합니다.
                            await playStop();
                            endTime = DateTime.now();
                            await calculateElapsedTime(
                                    playTrackTitleTime.last['time']!, endTime!)
                                .then((playingTime) {
                              playTrackTitleTime.last = ({
                                "name": playList[playingTrackIndex],
                                "time": playingTime,
                              });
                            });
                            await trackPlay('ready', playList[index]);
                            startTime = DateTime.now();
                            playTrackTitleTime.add({
                              "name": playList[index],
                              "time": startTime,
                            });
                          }
                        } else {
                          // true인 항목이 없다면, 선택한 트랙을 재생
                          provider.updatePlayListIndex(
                              index, true); // 선택한 트랙을 재생 상태로 설정합니다.
                          await trackPlay('ready', playList[index]);
                          startTime = DateTime.now();
                          playTrackTitleTime.add(
                            {
                              "name": playList[index],
                              "time": startTime,
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '음원 ${widget.playCount}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xff5a5a5a),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // Center(
                    //   child: Text(
                    //     _position,
                    //     style: const TextStyle(
                    //       fontSize: 24,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Stack(
                      children: [
                        SizedBox(
                          width: containerSize,
                          height: containerSize,
                          // color: Colors.grey[200]?.withOpacity(0.5),
                          child: Center(
                            child: GestureDetector(
                              // 터치 이벤트 감지
                              onTapDown: (TapDownDetails details) {
                                // 터치된 부분의 상대적인 위치를 얻습니다 (위젯 내에서의 위치)
                                final localPosition = details.localPosition;
                                // 화면 전체에서의 위치를 얻고 싶다면 details.globalPosition을 사용하세요.

                                // 화면 중심을 기준으로 좌표를 조정합니다.
                                final adjustedX =
                                    localPosition.dx - widgetSize / 2;
                                final adjustedY =
                                    localPosition.dy - widgetSize / 2;

                                // 위젯의 중심을 기준으로 한 비율을 계산합니다. (0 ~ 1 사이의 값)
                                final ratioX =
                                    (adjustedX + (widgetSize / 2)) / widgetSize;
                                final ratioY =
                                    (adjustedY + (widgetSize / 2)) / widgetSize;

                                // 비율을 사용하여 -100에서 100 사이의 값으로 변환합니다.
                                final scaledX = (ratioX * 200) - 100;
                                final scaledY = -((ratioY * 200) - 100);
                                setState(() {
                                  circlePosition = localPosition;
                                  // 결과를 문자열로 저장합니다.
                                  _position =
                                      'X축: ${scaledX.ceil()}, Y축: ${scaledY.ceil()}';
                                });
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: widgetSize,
                                    height:
                                        widgetSize, // 여기서 Stack의 크기를 명시적으로 지정합니다.
                                    child: SvgPicture.asset(
                                        'assets/survey/axis/2axis.svg'),
                                  ),
                                  groupNumber == 1
                                      ? SizedBox(
                                          width: widgetSize,
                                          height:
                                              widgetSize, // 여기서 Stack의 크기를 명시적으로 지정합니다.
                                          child: SvgPicture.asset(
                                              'assets/survey/axis/4axis.svg'),
                                        )
                                      : const SizedBox.shrink(),
                                  circlePosition != null
                                      ? Positioned(
                                          left: circlePosition!.dx - 4,
                                          top: circlePosition!.dy - 4,
                                          child: const CircleAvatar(
                                            radius: 4, // 원의 반지름
                                            backgroundColor: Colors.red,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          width: containerSize,
                          top: 0,
                          child: const Text(
                            '풍부한',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          width: containerSize,
                          bottom: 0,
                          child: const Text(
                            '공허한',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          top: containerSize / 2,
                          left: 0,
                          child: const Text(
                            '짜증스러운',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          top: containerSize / 2,
                          right: 0,
                          child: const Text(
                            '편안한',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (groupNumber == 1)
                          const Positioned(
                            top: 4,
                            left: 0,
                            child: Text(
                              '통제적이지 않은',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff8a8a8a),
                              ),
                            ),
                          ),
                        if (groupNumber == 1)
                          const Positioned(
                            top: 4,
                            right: 0,
                            child: Text(
                              '흥미로운',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff8a8a8a),
                              ),
                            ),
                          ),
                        if (groupNumber == 1)
                          const Positioned(
                            bottom: 4,
                            left: 0,
                            child: Text(
                              '고립적인',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff8a8a8a),
                              ),
                            ),
                          ),
                        if (groupNumber == 1)
                          const Positioned(
                            bottom: 4,
                            right: 0,
                            child: Text(
                              '통제적인',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff8a8a8a),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
