import 'package:flutter/material.dart';
import 'package:get/get.dart';

commonSurveyDialog({
  required BuildContext context,
  required String dialogName,
  required String surveyTitle,
  required String surveyContent,
  required VoidCallback surveyOnPressed,
  required ValueChanged<int> onSurveyContentValueChange, // 이 부분을 추가

  String? surveyContentTitle,
  int? surveyContentValue,
  List<String>? surveyImageList,
  List<int>? surveyContentValueList,
}) {
  return Get.dialog(barrierDismissible: false, name: dialogName,
      StatefulBuilder(builder: (context, StateSetter setDialog) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      title: Text(
        surveyTitle,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(surveyContentTitle!, style: const TextStyle(fontSize: 15)),
          Text(surveyContent, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: GridView.builder(
                itemCount: surveyImageList!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.177,
                ),
                itemBuilder: ((BuildContext context, index) {
                  return Column(
                    children: [
                      Image.asset(surveyImageList[index]),
                      Radio(
                        value: surveyContentValueList![index],
                        groupValue: surveyContentValue,
                        onChanged: (value) {
                          setDialog(() {
                            onSurveyContentValueChange(value as int);
                            surveyContentValue = value;
                            surveyContentValueList[index] = surveyContentValue!;
                          });
                        },
                      ),
                    ],
                  );
                })),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setDialog(() {
              surveyOnPressed();
            });
          },
          child: const Text('확인', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }));
}
