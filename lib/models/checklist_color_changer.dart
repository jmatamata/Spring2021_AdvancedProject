import 'package:flutter/material.dart';

class TitleColorChanger {
  final List<int> deadlineColorList = [
    0xff8ede78,
    0xff9dde78,
    0xffa6de78,
    0xffb7de78,
    0xffc6de78,
    0xffd4de78,
    0xffdedb78,
    0xffded278,
    0xffdec378,
    0xffdeb278,
    0xffde9878,
    0xffde7878,
  ];

  Map<DateTime, Color> colorTimeFrames = {};

  DateTime _creationDate;

  Duration _deadlineIncrement;

  TitleColorChanger(DateTime creationDateIn, DateTime deadlineDateIn) {
    _creationDate = creationDateIn;

    _deadlineIncrement = deadlineDateIn.difference(creationDateIn) ~/ 12;

    for (int i = 1; i <= 12; i++) {
      colorTimeFrames[creationDateIn.add(_deadlineIncrement * i)] =
          Color(deadlineColorList[i - 1]);
    }
  }

  Color getTitleColor(DateTime updatedTime) {
    Duration shortestTime = _deadlineIncrement;

    DateTime closestTimeFrame = _creationDate;

    colorTimeFrames.forEach((timeFrame, color) {
      if (timeFrame.difference(updatedTime).abs() < shortestTime) {
        closestTimeFrame = timeFrame;
      }
    });

    return (closestTimeFrame != null)
        ? colorTimeFrames[closestTimeFrame]
        : Color(0xffffffff);
  }
}
