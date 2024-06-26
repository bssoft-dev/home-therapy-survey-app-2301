import 'package:flutter/material.dart';
import 'package:home_therapy_survey_app/widgets/track_player_widget.dart';
import 'package:home_therapy_survey_app/widgets/background_container_widget.dart';
import 'package:home_therapy_survey_app/utils/main_color.dart';
import 'package:home_therapy_survey_app/widgets/device_info_dialog_widget.dart';
import 'package:home_therapy_survey_app/widgets/device_scann_dialog_widget.dart';
import 'package:home_therapy_survey_app/widgets/volume_controller_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<bool>? asyncMethodFuture;
  String? trackTitle;

  @override
  void initState() {
    super.initState();
    asyncMethodFuture = asyncTrackPlayListMethod();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MainColor mainColor = MainColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Color(0xff5a5a5a),
                size: 40,
              ),
              onPressed: () => Navigator.pop(context)),
        ),
        body: backgroundContainer(
            context: context,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                settingTile('기기 검색', Icons.search_rounded, () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return DeviceScannDialog(filteredAddresses);
                    },
                  );
                }),
                settingTile('기기 정보', Icons.info_rounded, () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return const DeviceInfoDialog();
                    },
                  );
                }),
                FutureBuilder<bool>(
                    future: asyncMethodFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == true) {
                          return settingTile(
                              '음원 미리듣기', Icons.audiotrack_rounded, () {
                            prePlayTrack(
                                context: context,
                                trackTitle: '미리듣기',
                                actionText: '확인',
                                volumeSlider: const VolumeController());
                          });
                        } else {
                          return const Text('');
                        }
                      } else {
                        return const SizedBox();
                      }
                    }),
              ],
            )));
  }
}

Widget settingTile(String title, IconData icon, void Function()? onTap) {
  final MainColor mainColor = MainColor();
  return Column(
    children: [
      ListTile(
        leading: Icon(
          icon,
          // color: mainColor.mainColor(),
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            // color: mainColor.mainColor(),
            fontSize: 20,
          ),
        ),
        onTap: onTap,
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          // color: mainColor.mainColor(),
        ),
      ),
      const Divider(
        color: Colors.black12,
        indent: 20,
        endIndent: 20,
      )
    ],
  );
}
