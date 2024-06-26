import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_survey_app/model/info_model.dart';
import 'package:home_therapy_survey_app/utils/http_request_api.dart';
import 'package:home_therapy_survey_app/utils/main_color.dart';
import 'package:home_therapy_survey_app/utils/share_rreferences_future.dart';
import 'package:home_therapy_survey_app/widgets/noti_snackbar_widget.dart';
import 'package:home_therapy_survey_app/widgets/pre_survey_dialog/apartment_noise_survey_dialog.dart';
import 'package:lottie/lottie.dart';

final MainColor mainColor = MainColor();
final _formKey = GlobalKey<FormState>();
String genderGroupValue = '남성';
String noiseSensitivityGroupValue = '상';
String sincerityGroupValue = '상';

Future<dynamic> showUserInfoDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required TextEditingController usernameController,
  required TextEditingController ageController,
  required TextEditingController jobController,
  required TextEditingController snController,
  required VoidCallback editTitleOnPressed,
  required VoidCallback editContentOnPressed,
  required String cancelText,
  required String saveText,
  VoidCallback? saveOnPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    name: '개인정보',
    // barrierColor: Colors.red.withOpacity(0.5),
    StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Scaffold(
          resizeToAvoidBottomInset: false, // 이 부분을 추가
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: StatefulBuilder(
                  builder: (context, StateSetter setDialog) {
                    return AlertDialog(
                      actionsPadding: const EdgeInsets.only(bottom: 10),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != '')
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Lottie.asset(
                                        'assets/lottie/user_info.json',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.fill,
                                        repeat: false,
                                        animate: true),
                                  ),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          textBox(
                              'Name', usernameController, '이름', '이름을 입력해주세요.'),
                          const SizedBox(
                            height: 5,
                          ),
                          textBox('Age', ageController, '나이', '나이를 입력해주세요.'),
                          const SizedBox(
                            height: 5,
                          ),
                          textBox(
                              'Job', jobController, '직업', '사용자의 직업을 입력해주세요.'),
                          const SizedBox(
                            height: 5,
                          ),
                          textBox(
                              'Sn', snController, '설치 아이디', '설치 아이디를 입력해주세요.'),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      actions: [
                        const Divider(
                          color: Colors.black12,
                          thickness: 0.8, //thickness of divier line
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  cancelText,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )),
                            TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  await httpPostServer(
                                          path:
                                              'api/users/${snController.text}/${usernameController.text}',
                                          data: userInfo(
                                            username: usernameController.text,
                                            age: ageController.text,
                                            job: jobController.text,
                                            sn: snController.text,
                                          ).toJson())
                                      .then((value) {
                                    if (value == 200) {
                                      //한번만 호출되도록 하는 캐시 저장코드
                                      saveStoredValue('sn', snController.text);
                                      saveStoredValue(
                                          'username', usernameController.text);
                                      Get.back();
                                      // apartmentNoiseServeyDialogQ1(
                                      //     context: context);
                                    } else {
                                      failSnackBar(
                                          '오류', '개인정보 저장에 실패했습니다. 다시 시도해주세요');
                                    }
                                  });
                                }
                              },
                              child: Text(
                                saveText,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget textBox(String formTitle, TextEditingController textEditingController,
    String hintText, String? validatorText) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        formTitle,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xff5a5a5a),
        ),
      ),
    ),
    subtitle: TextFormField(
      autovalidateMode: AutovalidateMode.always,
      controller: textEditingController,
      onSaved: (saveValue) => textEditingController.text = saveValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return validatorText;
        }
        return null;
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: Color(0xff5cb85c),
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        hintText: hintText,
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );
}

Widget radioBox(String radioTitle, String groupValue, String firstValue,
    String secondValue, String thirdValue) {
  return StatefulBuilder(builder: (context, StateSetter setDialog) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            radioTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(firstValue, style: const TextStyle(fontSize: 16)),
                  Radio(
                      value: firstValue,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setDialog(() {
                          groupValue = value.toString();
                        });
                      }),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Text(secondValue, style: const TextStyle(fontSize: 16)),
                  Radio(
                      value: secondValue,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setDialog(() {
                          groupValue = value.toString();
                        });
                      }),
                ],
              ),
              if (thirdValue != '')
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(thirdValue, style: const TextStyle(fontSize: 16)),
                    Radio(
                        value: thirdValue,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setDialog(() {
                            groupValue = value.toString();
                          });
                        }),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  });
}
