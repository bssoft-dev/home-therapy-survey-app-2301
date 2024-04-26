import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_app/model/play_number_model.dart';
import 'package:home_therapy_app/utils/main_color.dart';
import 'package:home_therapy_app/widgets/background_container_widget.dart';
import 'package:home_therapy_app/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';

class SuveyIdInput extends StatelessWidget {
  const SuveyIdInput({super.key});

  @override
  Widget build(BuildContext context) {
    List<Session2> session2Result =
        context.read<PlayNumberProvider>().session2Result;
    print(session2Result);

    final TextEditingController suveyIdController = TextEditingController();

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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // 반투명한 Container
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '설문지에 기재한 ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Color(0xff5a5a5a),
                            ),
                          ),
                          const Text(
                            'ID를 입력해주세요',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              color: Color(0xff5a5a5a),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              controller: suveyIdController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: 'ID를 입력하세요',
                              ),
                            ),
                          ),
                        ],
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
                        // 다음 세션으로 이동
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const PlayTouchPosition(
                        //       playCount: 1,
                        //     ),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            MainColor().mainColor().withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 20),
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
