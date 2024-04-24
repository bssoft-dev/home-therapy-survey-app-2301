import 'package:flutter/material.dart';

class PlayTouchPosition extends StatefulWidget {
  const PlayTouchPosition({super.key});

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
    // 위젯의 너비와 높이를 정의합니다.
    final screenWidth = MediaQuery.of(context).size.width;
    final widgetSize = screenWidth * 0.8; //  화면 너비의 80%

    return Scaffold(
      appBar: AppBar(
        title: const Text('터치 위치 확인'),
      ),
      backgroundColor: Colors.grey[400],
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  _position,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                // 터치 이벤트 감지
                onTapDown: (TapDownDetails details) {
                  // 터치된 부분의 상대적인 위치를 얻습니다 (위젯 내에서의 위치)
                  final localPosition = details.localPosition;
                  // 화면 전체에서의 위치를 얻고 싶다면 details.globalPosition을 사용하세요.

                  // 화면 중심을 기준으로 좌표를 조정합니다.
                  final adjustedX = localPosition.dx - widgetSize / 2;
                  final adjustedY = localPosition.dy - widgetSize / 2;

                  // 위젯의 중심을 기준으로 한 비율을 계산합니다. (0 ~ 1 사이의 값)
                  final ratioX = (adjustedX + (widgetSize / 2)) / widgetSize;
                  final ratioY = (adjustedY + (widgetSize / 2)) / widgetSize;

                  // 비율을 사용하여 -100에서 100 사이의 값으로 변환합니다.
                  final scaledX = (ratioX * 200) - 100;
                  final scaledY = -((ratioY * 200) - 100);
                  setState(() {
                    circlePosition = localPosition;
                    // 결과를 문자열로 저장합니다.
                    _position = 'X축: ${scaledX.ceil()}, Y축: ${scaledY.ceil()}';
                  });
                },
                child: Stack(
                  children: [
                    // const Positioned(
                    //   left: 25, // 원의 중심을 터치 위치에 맞추기 위해 조정
                    //   top: 25, // 원의 중심을 터치 위치에 맞추기 위해 조정
                    //   child: CircleAvatar(
                    //     radius: 25, // 원의 반지름
                    //     backgroundColor: Colors.red,
                    //   ),
                    // ),
                    Positioned(
                        left: widgetSize / 2,
                        top: 0,
                        child: Container(
                          color: Colors.grey[500],
                          width: 1,
                          height: widgetSize,
                        )),
                    Positioned(
                        left: 0,
                        top: widgetSize / 2,
                        child: Container(
                          color: Colors.grey[500],
                          width: widgetSize,
                          height: 1,
                        )),
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
                    Container(
                      width: widgetSize,
                      height: widgetSize, // 여기서 Stack의 크기를 명시적으로 지정합니다.
                      color: Colors.grey[200]?.withOpacity(0.2),
                      child: const Center(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
