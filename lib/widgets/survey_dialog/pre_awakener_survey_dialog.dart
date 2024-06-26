import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_survey_app/utils/assets_image_list_future.dart';
import 'package:home_therapy_survey_app/widgets/survey_dialog/common_survey.dart';
import 'package:home_therapy_survey_app/widgets/survey_dialog/therapy_play_dialog.dart';

List<String>? preAwakeList;
int preAwakeValue = 0;
List<int>? preAwakeValueList;
preAwakeServeyDialog({
  required BuildContext context,
  bool? noiseCheckResult,
  int? preEmotionCheckResult,
  List<int>? noiseTypeValue,
  int? noiseTypeScoreValue,
}) {
  loadAssetSVGs('awakener').then((value) {
    preAwakeList = value;
    preAwakeValueList =
        List<int>.generate(preAwakeList!.length, (index) => index);

    return commonSurveyDialog(
      context: context,
      dialogName: '각성가설문',
      surveyTitle: '질문 5/5',
      surveyContentTitle: '[각성가]',
      surveyContent: '현재 본인과 가장 알맞는 감정 상태를 고르시오',
      surveyImageList: preAwakeList,
      surveyContentValueList: preAwakeValueList,
      surveyContentValue: preAwakeValue,
      onSurveyContentValueChange: (value) => preAwakeValue = value,
      surveyOnPressed: () {
        Get.back();
        therapyPlay(
          context: context,
          noiseCheckResult: noiseCheckResult,
          noiseTypeValue: noiseTypeValue,
          noiseTypeScoreValue: noiseTypeScoreValue,
          preEmotionCheckResult: preEmotionCheckResult,
          preAwakeCheckResult: preAwakeValue,
        );
        debugPrint(('noiseDialog:$noiseCheckResult'));
        debugPrint(('noiseType:$noiseTypeValue'));
        debugPrint(('noiseTypeScore:$noiseTypeScoreValue'));
        debugPrint(('PreemotionDialog:$preEmotionCheckResult'));
        debugPrint(('PreawakeDialog:$preAwakeValue'));
        preAwakeValue = 0;
      },
    );
  });
}
