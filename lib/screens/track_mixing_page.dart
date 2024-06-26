import 'package:flutter/material.dart';
import 'package:home_therapy_survey_app/widgets/background_container_widget.dart';
import 'package:home_therapy_survey_app/utils/main_color.dart';
import 'package:home_therapy_survey_app/widgets/track_player_widget.dart';

class TrackMixing extends StatefulWidget {
  const TrackMixing({super.key});

  @override
  State<TrackMixing> createState() => _TrackMixingState();
}

class _TrackMixingState extends State<TrackMixing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MainColor mainColor = MainColor();
  List<bool> containerSelected =
      List.generate(trackPlayList.length, (_) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: const Icon(
                color: Color(0xff5a5a5a),
                Icons.close_rounded,
                size: 50,
              ),
              onPressed: () => Navigator.pop(context))),
      body: backgroundContainer(
        context: context,
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  '음원믹스',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                mixTrackList(containerColors: containerSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
