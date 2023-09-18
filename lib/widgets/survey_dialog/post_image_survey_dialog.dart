import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_app/widgets/custom_button_widget.dart';
import 'package:home_therapy_app/widgets/noti_snackbar_widget.dart';
import 'package:home_therapy_app/widgets/survey_dialog/post_emtion_survey_dialog.dart';

Offset? marker;
List<dynamic>? comportPlot;

comportPlotServeyDialog({
  required BuildContext context,
  bool? noiseCheckResult,
  int? preEmotionCheckResult,
  int? preAwakeCheckResult,
  List<dynamic>? playTrackTitleReuslt,
}) {
  return Get.dialog(barrierDismissible: false, name: '청취후감정설문',
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
          const Text('현재 본인과 비슷한 감정 상태 유형을 고르시오',
              style: TextStyle(fontSize: 15)),
          const SizedBox(height: 15),
          GestureDetector(
              onTapDown: (TapDownDetails details) {
                setDialog(() {
                  marker = details.localPosition;
                  comportPlot = [(marker!.dx), (marker!.dy)];
                });
              },
              child: Stack(
                children: [
                  Image.asset('assets/survey/comport_ploat.png'),
                  if (marker != null)
                    Positioned(
                      left: marker!.dx - 20,
                      top: marker!.dy - 50,
                      child: Icon(Icons.where_to_vote,
                          size: 50, color: mainColor.mainColor()),
                    ),
                ],
              )),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('확인', style: TextStyle(fontSize: 20)),
          onPressed: () async {
            if (comportPlot!.isEmpty) {
              failSnackBar('오류', '감정 상태를 선택해주세요.');
            } else {
              Get.back();
              await postEmotionServeyDialog(
                  context: context,
                  noiseCheckResult: noiseCheckResult,
                  preEmotionCheckResult: preEmotionCheckResult,
                  preAwakeCheckResult: preAwakeCheckResult,
                  playTrackTitleReuslt: playTrackTitleReuslt,
                  comportPlotResult: comportPlot);

              debugPrint(('noiseDialog:$noiseCheckResult'));
              debugPrint(('PreemotionDialog:$preEmotionCheckResult'));
              debugPrint(('PreawakeDialog:$preAwakeCheckResult'));
              debugPrint(('tracks:$playTrackTitleReuslt'));
              debugPrint(('comportPlot:$comportPlot'));
              comportPlot = [];
              marker = null;
            }
          },
        ),
      ],
    );
  })));
}