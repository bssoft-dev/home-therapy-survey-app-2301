import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:home_therapy_app/utils/share_rreferences_request.dart';
import 'package:home_therapy_app/utils/main_color_widget.dart';
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
  required TextEditingController nameController,
  required TextEditingController installLocationController,
  required TextEditingController installIdController,
  required VoidCallback editTitleOnPressed,
  required VoidCallback editContentOnPressed,
  required String cancelText,
  required String saveText,
  VoidCallback? saveOnPressed,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Form(
          key: _formKey,
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
              child: StatefulBuilder(builder: (context, StateSetter setDialog) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    actionsPadding: const EdgeInsets.only(bottom: 10),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != '')
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                        radioBox('Gender', genderGroupValue, '여성', '남성', ''),
                        const SizedBox(
                          height: 5,
                        ),
                        textBox(
                            'Full Test', nameController, '이름', '이름을 입력해주세요.'),
                        const SizedBox(
                          height: 5,
                        ),
                        textBox('Install Location', installLocationController,
                            '설치 위치', '설치 위치를 입력해주세요.'),
                        const SizedBox(
                          height: 5,
                        ),
                        textBox('Install ID', installIdController, '설치 아이디',
                            '설치 아이디를 입력해주세요.'),
                        const SizedBox(
                          height: 5,
                        ),
                        radioBox('소음 민감도', noiseSensitivityGroupValue, '상', '중',
                            '하'),
                        const SizedBox(
                          height: 5,
                        ),
                        radioBox('성실도', sincerityGroupValue, '상', '중', '하'),
                      ],
                    ),
                    actions: [
                      Divider(
                        color: mainColor.mainColor(),
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              )),
                          TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  //db에 저장하는 과정 필요
                                  debugPrint(nameController.text);
                                  debugPrint(installLocationController.text);
                                  debugPrint(installIdController.text);
                                  debugPrint(genderGroupValue);
                                  debugPrint(noiseSensitivityGroupValue);
                                  debugPrint(sincerityGroupValue);

                                  //한번만 호출되도록 하는 캐시 저장코드
                                  // saveStoredValue(
                                  //     'Install_ID', '$installIdController.text');
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(saveText,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400)))
                        ],
                      )
                    ],
                  ),
                );
              })),
        );
      });
}

Widget textBox(String formTitle, TextEditingController textEditingController,
    String hintText, String? validatorText) {
  return ListTile(
    title: Text(formTitle,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: hintText,
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
                  Text(firstValue, style: const TextStyle(fontSize: 15)),
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
                  Text(secondValue, style: const TextStyle(fontSize: 15)),
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
                    Text(thirdValue, style: const TextStyle(fontSize: 15)),
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