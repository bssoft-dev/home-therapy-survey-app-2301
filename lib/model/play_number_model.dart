import 'package:flutter/foundation.dart';
import 'dart:core';
import 'package:flutter/material.dart';

class Session1 {
  String name;
  Duration time;

  Session1({
    required this.name,
    required this.time,
  });

  String get _name => name;
  Duration get _time => time;
  @override
  String toString() {
    return '{name: $name, time: $time}';
  }
}

class Session2 {
  String name;
  Duration time;
  List<int> position;

  Session2({
    required this.name,
    required this.time,
    required this.position,
  });

  String get _name => name;
  Duration get _time => time;
  List<int> get _position => position;

  @override
  String toString() {
    return '{name: $name, time: $time, position: $position}';
  }
}

class PlayNumberProvider extends ChangeNotifier {
  int _playNumber = 1;
  int _totalNumber = 17;
  int _groupNumber = 1;
  late dynamic _survey_id;

  // 음원 정보
  List<dynamic> _playList = [];
  final List<int> _session1PlayList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17
  ];
  final List<int> _session2PlayList = [
    1,
    2,
    17,
    16,
    15,
    14,
    13,
    12,
    11,
    10,
    9,
    8,
    7,
    6,
    5,
    4,
    3
  ];

  List<bool> _playListIndex = [];

  // 세션 1 결과
  final List<Session1> _session1Result = [];
  // 세션 2 결과
  final List<Session2> _session2Result = [];

  int get playNumber => _playNumber;
  int get totalNumber => _totalNumber;
  int get groupNumber => _groupNumber;
  dynamic get userID => _survey_id;
  List<dynamic> get playList => _playList;
  List<int> get session1PlayList => _session1PlayList;
  List<int> get session2PlayList => _session2PlayList;
  List<bool> get playListIndex => _playListIndex;
  List<Session1> get session1Result => _session1Result;
  List<Session2> get session2Result => _session2Result;

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

  void setPlayList(List<dynamic> trackPlayList) {
    _playList = trackPlayList;
    _playListIndex = List<bool>.generate(
      _totalNumber,
      (int index) => false,
      growable: true,
    );
    notifyListeners();
  }

  void updatePlayListIndex(int index, bool state) {
    _playListIndex[index] = state;
    notifyListeners();
  }

  void addSession1Result(String name, Duration time) {
    _session1Result.add(Session1(
      name: name,
      time: time,
    ));
    notifyListeners();
  }

  void addSession2Result(
    String name,
    Duration time,
    List<int> position,
  ) {
    _session2Result.add(Session2(
      name: name,
      time: time,
      position: position,
    ));
    notifyListeners();
  }
}
