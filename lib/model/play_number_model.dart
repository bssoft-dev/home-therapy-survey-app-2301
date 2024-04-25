import 'package:flutter/foundation.dart';
import 'dart:core';

class Session1 {
  int number;
  Duration time;
  Session1({
    required this.number,
    required this.time,
  });
}

class PlayNumberProvider extends ChangeNotifier {
  int _playNumber = 1;
  int _totalNumber = 1;
  int _groupNumber = 1;
  final Stopwatch _stopwatch = Stopwatch();
  List<String> _playList = [];
  List<bool> _playListIndex = [];

  // 세션 1 결과
  final List<Session1> _session1Result = [];

  int get playNumber => _playNumber;
  int get totalNumber => _totalNumber;
  int get groupNumber => _groupNumber;
  Stopwatch get stopwatch => _stopwatch;
  List<String> get playList => _playList;
  List<bool> get playListIndex => _playListIndex;
  List<Session1> get session1Result => _session1Result;

  void setTotalNumber(int count) {
    _totalNumber = count;
    notifyListeners();
  }

  void setPlayNumber(int count) {
    if (count <= _totalNumber) {
      _playNumber = count;
      notifyListeners();
    }
  }

  void resetPlayNumber() {
    _playNumber = 1;
    notifyListeners();
  }

  void setGroupNumber(int groupNumber) {
    _groupNumber = groupNumber;
    notifyListeners();
  }

  void setStopwatch(int count) {
    // playNumber가 1일 때, Stopwatch 시작
    if (_playNumber == 1 && _stopwatch.isRunning == false) {
      print('Stopwatch start');
      _stopwatch.start();
    }

    // playNumber가 totalNumber와 같을 때, Stopwatch 멈춤
    if (_playNumber == _totalNumber) {
      _stopwatch.stop();
      // 여기서 경과 시간을 출력하거나 다른 처리를 할 수 있습니다.
      print('Elapsed time: ${_stopwatch.elapsed}');
    }
    notifyListeners();
  }

  void setPlayList(List<String> trackPlayList) {
    _playList = trackPlayList.sublist(0, _totalNumber);
    _playListIndex =
        List<bool>.generate(_totalNumber, (int index) => false, growable: true);
    notifyListeners();
  }

  void updatePlayListIndex(int index, bool state) {
    _playListIndex[index] = state;
    notifyListeners();
  }

  void addSession1Result(int number, Duration time) {
    _session1Result.add(Session1(number: number, time: time));
    notifyListeners();
  }
}
