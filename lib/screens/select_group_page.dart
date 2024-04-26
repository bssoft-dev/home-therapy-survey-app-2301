import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_therapy_app/screens/play_page.dart';
import 'package:home_therapy_app/screens/settings_page.dart';
import 'package:home_therapy_app/utils/main_color.dart';
import 'package:home_therapy_app/widgets/appbar_widget.dart';
import 'package:home_therapy_app/widgets/background_container_widget.dart';
import 'package:home_therapy_app/widgets/custom_button_widget.dart';
import 'package:home_therapy_app/widgets/track_player_widget.dart';
import 'package:provider/provider.dart';
import 'package:home_therapy_app/model/play_number_model.dart';

class SelectGroup extends StatefulWidget {
  const SelectGroup({super.key});

  @override
  State<SelectGroup> createState() => _SelectGroupState();
}

class _SelectGroupState extends State<SelectGroup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _totalNumberController = TextEditingController();
  final MainColor mainColor = MainColor();
  Future<bool>? asyncMethodFuture;
  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    asyncMethodFuture = asyncTrackPlayListMethod();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncMethodFuture?.then((isConnected) {
        if (isConnected) {
          // selectPlayNumberDialog();
          setState(() {
            list = trackPlayList;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        foregroundColor: const Color(0xff5A5A5A),
        actions: [
          simpleIconButton(Icons.settings_rounded, 40, const Color(0xff5A5A5A),
              () {
            Get.toNamed('setting');
          }),
        ],
      ),
      endDrawer: const Settings(),
      extendBodyBehindAppBar: true,
      body: backgroundContainer(
        context: context,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              list.isNotEmpty
                  ? GroupButton(
                      color: mainColor.mainColor(),
                      text: 'Group 1',
                      groupNumber: 1,
                      list: list,
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 80,
              ),
              list.isNotEmpty
                  ? GroupButton(
                      color: const Color(0xff5a5a5a),
                      text: 'Group 2',
                      groupNumber: 2,
                      list: list,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void selectPlayNumberDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        PlayNumberProvider provider = Provider.of<PlayNumberProvider>(context);
        return AlertDialog(
          actionsPadding: const EdgeInsets.only(bottom: 10),
          title: const Text('음원갯수 선택'),
          content: TextField(
            controller: _totalNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintText: '청취할 음원의 갯수를 입력하세요',
            ),
          ),
          actions: [
            const Divider(
              color: Colors.black12,
              thickness: 0.8, //thickness of divier line
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    if (_totalNumberController.text.trim().isNotEmpty) {
                      final int totalNumber =
                          int.parse(_totalNumberController.text);
                      provider.setTotalNumber(totalNumber);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class GroupButton extends StatelessWidget {
  const GroupButton({
    super.key,
    required this.color,
    required this.text,
    required this.groupNumber,
    required this.list,
  });

  final Color color;
  final String text;
  final int groupNumber;
  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    PlayNumberProvider provider = Provider.of<PlayNumberProvider>(context);
    return GestureDetector(
      onTap: () {
        provider.setGroupNumber(groupNumber);
        final int pageNumber = context.read<PlayNumberProvider>().playNumber;
        provider.setPlayList(list);
        Get.to(
          () => PlayMusic(
            playCount: pageNumber,
          ),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
