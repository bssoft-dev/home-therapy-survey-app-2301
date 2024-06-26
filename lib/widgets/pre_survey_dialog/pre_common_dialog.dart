import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_survey_app/model/survey_word_position_model.dart';
import 'package:home_therapy_survey_app/widgets/pre_survey_dialog/survey_question_list.dart';
import 'package:home_therapy_survey_app/widgets/range_dropdown_widget.dart';

Future<List<int>> fetchData() async {
  return List<int>.generate(101 - 0, (i) => i + 0);
}

preCommonSurveyDialog({
  required BuildContext context,
  required String dialogName,
  required String surveyTitle,
  required List<String> questionTitle,
  required int radioNumber,
  required int noteNumber,
  required int questionNumber,
  required int questionValue,
  required List<int> questionResultList,
  required VoidCallback surveyOnPressed,
  required ValueChanged<WordPositionSurvey> onSurveyMapValueChange,
  required ValueChanged<int> onSurveyContentValueChange,
  final String? surveyStageTitle,
  final String? prefixQuestionTitle,
}) {
  return Get.dialog(
      barrierDismissible: false, name: dialogName, useSafeArea: false,
      StatefulBuilder(builder: (context, StateSetter setDialog) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      title: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          surveyStageTitle != null
              ? Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surveyStageTitle,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                  ],
                )
              : const SizedBox.shrink(),
          !(surveyTitle.contains('매우 동의한다'))
              ? Text(
                  surveyTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                )
              : const SizedBox.shrink(),
          // const SizedBox(height: 10),
          // Text(
          //   '※ ${note[noteNumber]}',
          //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          // )
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              surveyTitle.contains('매우 동의한다')
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        surveyTitle,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                child: Column(
                    children:
                        List.generate(questionNumber, (int questionIndex) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      prefixQuestionTitle != null
                          ? Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${questionIndex + 1}. $prefixQuestionTitle',
                                  ),
                                  TextSpan(
                                    text: questionTitle[questionIndex],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              '${questionIndex + 1}.${questionTitle[questionIndex]}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 17),
                            ),
                      const SizedBox(height: 10),
                      if (surveyTitle.contains('동의하는 정도를'))
                        Padding(
                          padding: const EdgeInsets.only(left: 2, bottom: 12),
                          child: Column(
                            children: List.generate(radioNumber, (choiceIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    value: choiceIndex,
                                    groupValue:
                                        questionResultList[questionIndex],
                                    onChanged: (value) {
                                      setDialog(() {
                                        questionResultList[questionIndex] =
                                            value as int;
                                        onSurveyMapValueChange(
                                            WordPositionSurvey(
                                                questionIndex, value));
                                        onSurveyContentValueChange(value);
                                      });
                                    },
                                  ),
                                  Text(
                                    wordPositionRatingText[choiceIndex],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              );
                            }),
                          ),
                        )
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // 가로 스크롤 사용
                          child: Row(
                            children: List.generate(radioNumber, (choiceIndex) {
                              return Column(
                                children: [
                                  if (!surveyTitle.contains('성격 특성') &&
                                      !surveyTitle.contains('공간'))
                                    Text(ratingText[choiceIndex],
                                        style: const TextStyle(fontSize: 15)),
                                  if (surveyTitle.contains('성격 특성'))
                                    Text(tipiRatingText[choiceIndex],
                                        style: const TextStyle(fontSize: 15)),
                                  // if (surveyTitle
                                  //     .contains('공간')) // 사운드 스케이프 질문
                                  //   Text(wordPositionRatingText[choiceIndex],
                                  //       style: const TextStyle(fontSize: 15)),
                                  Radio(
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    value: choiceIndex,
                                    groupValue:
                                        questionResultList[questionIndex],
                                    onChanged: (value) {
                                      setDialog(() {
                                        questionResultList[questionIndex] =
                                            value as int;
                                        onSurveyMapValueChange(
                                            WordPositionSurvey(
                                                questionIndex, value));
                                        onSurveyContentValueChange(value);
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10)
                                ],
                              );
                            }),
                          ),
                        ),
                    ],
                  );
                })),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: surveyOnPressed,
          child: const Text('확인', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }));
}
