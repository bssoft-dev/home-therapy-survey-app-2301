import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_app/widgets/custom_button_widget.dart';
import 'package:home_therapy_app/widgets/noti_snackbar_widget.dart';
import 'package:home_therapy_app/widgets/survey_dialog/pre_emotion_survey_dialog.dart';

bool isYesCheck = false;
bool isNoCheck = false;
bool? noiseCheckResult;
noiseServeyDialog({
  required BuildContext context,
}) {
  return Get.dialog(barrierDismissible: false, name: '소음여부설문',
      StatefulBuilder(builder: ((context, StateSetter setDialog) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      title: const Text(
        '질문 1/3',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('현재 층간소음이 있습니까?', style: TextStyle(fontSize: 15)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              changeIconButton(
                icon: Icons.check_circle_outline,
                size: 80,
                isChange: isYesCheck,
                iconColor: Colors.black,
                alternateIconColor: mainColor.mainColor(),
                onPressed: () {
                  setDialog(() {
                    isYesCheck = !isYesCheck;
                    if (isYesCheck) {
                      isNoCheck = false;
                    }
                    noiseCheckResult = true;
                  });
                },
              ),
              changeIconButton(
                icon: Icons.highlight_off,
                size: 80,
                isChange: isNoCheck,
                iconColor: Colors.black,
                alternateIconColor: mainColor.mainColor(),
                onPressed: () {
                  setDialog(() {
                    isNoCheck = !isNoCheck;
                    if (isNoCheck) {
                      isYesCheck = false;
                    }
                    noiseCheckResult = false;
                  });
                },
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('확인', style: TextStyle(fontSize: 20)),
          onPressed: () async {
            if (isNoCheck || isYesCheck) {
              Get.back();
              await preEmotionServeyDialog(
                  context: context, noiseCheckResult: noiseCheckResult);

              debugPrint(('noiseDialog:$noiseCheckResult'));
              setDialog(() {
                isYesCheck = false;
                isNoCheck = false;
              });
            } else {
              failSnackBar('오류', '소음여부를 선택해주세요.');
            }
          },
        ),
      ],
    );
  })));
}
