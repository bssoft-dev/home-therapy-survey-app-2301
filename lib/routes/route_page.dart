import 'package:get/get.dart';

import 'package:home_therapy_survey_app/routes/route_name.dart';
import 'package:home_therapy_survey_app/screens/home_page.dart';
import 'package:home_therapy_survey_app/screens/rest_page.dart';
import 'package:home_therapy_survey_app/screens/select_group_page.dart';
import 'package:home_therapy_survey_app/screens/settings_page.dart';
import 'package:home_therapy_survey_app/screens/device_page.dart';
import 'package:home_therapy_survey_app/screens/track_mixing_page.dart';
import 'package:home_therapy_survey_app/screens/suvey_id_input_page.dart';

class RoutePage {
  static final page = [
    GetPage(
      name: RouteName.home,
      page: () => const Home(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.therapyDevice,
      page: () => const DevicePlayer(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.setting,
      page: () => const Settings(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 150),
    ),
    GetPage(
      name: RouteName.trackMixing,
      page: () => const TrackMixing(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.selectGroup,
      page: () => const SelectGroup(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.rest,
      page: () => const Rest(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: RouteName.surveyIdInput,
      page: () => SuveyIdInput(),
      transition: Transition.noTransition,
    ),
  ];
}
