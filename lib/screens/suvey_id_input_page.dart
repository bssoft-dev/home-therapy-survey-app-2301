import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_survey_app/utils/http_request_api.dart';
import 'package:home_therapy_survey_app/widgets/noti_snackbar_widget.dart';
import 'package:http/http.dart' as http;
import 'package:home_therapy_survey_app/model/play_number_model.dart';
import 'package:home_therapy_survey_app/utils/main_color.dart';
import 'package:home_therapy_survey_app/widgets/background_container_widget.dart';
import 'package:home_therapy_survey_app/widgets/custom_button_widget.dart';
import 'package:provider/provider.dart';

class SuveyIdInput extends StatelessWidget {
  SuveyIdInput({super.key});

  final TextEditingController suveyIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PlayNumberProvider provider = Provider.of<PlayNumberProvider>(context);
    List<Session1> session1Result = provider.session1Result;
    List<Session2> session2Result = provider.session2Result;
    print(session2Result);
    int group = provider.groupNumber;

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
                            child: TextFormField(
                              controller: suveyIdController,
                              onSaved: (saveValue) =>
                                  suveyIdController.text = saveValue!,
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
                        // 설문지 ID를 서버로 전송
                        Map data = {
                          "survey_id": suveyIdController.text,
                          "group": group,
                          "session1": session1Result
                              .map((session) => session.toMap())
                              .toList(),
                          "session2": session2Result
                              .map((session) => session.toMap())
                              .toList(),
                        };
                        httpPostServer(data: data).then((value) {
                          if (value == 200) {
                            successSnackBar(
                                context, '설문 저장에 성공했습니다', '수고하셨습니다.');
                            Get.toNamed('home');
                          } else {
                            failSnackBar('오류', '설문 저장에 실패했습니다. 다시 시도해주세요');
                          }
                        });
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

httpPostServer({
  required Map data,
}) async {
  String baseUrl = 'https://api-2301.bs-soft.co.kr/api/survey/202405';
  var body = jsonEncode(data);
  debugPrint(body);
  try {
    http.Response response =
        await http.post(Uri.parse(baseUrl), body: body, headers: {
      "accept": "application/json",
      "Content-Type": "application/json",
    });
    return response.statusCode;
  } catch (e) {
    print(e);
    // 서버가 응답하지 않는 경우
    httpFailureNotice();
    return 503;
  }
}
