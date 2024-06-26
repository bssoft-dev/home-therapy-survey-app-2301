import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_survey_app/widgets/custom_button_widget.dart';

basicAppBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    backgroundColor: Colors.transparent,
    actions: [
      simpleIconButton(Icons.settings_rounded, 40, const Color(0xff5A5A5A), () {
        Get.toNamed('setting');
      }),
    ],
    elevation: 0,
  );
}
