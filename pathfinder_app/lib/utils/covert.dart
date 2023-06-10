import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/difficulty.dart';
import '../models/time.dart';
import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");

  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }

  return Color(int.parse(hexColor, radix: 16));
}

double stringToDouble(String value) {
  return double.parse(value);
}

int stringToInt(String value) {
  return int.parse(value);
}

Difficulty stringToDifficulty(String value) {
  switch (value) {
    case 'easy':
      return Difficulty.easy;
    case 'mediu':
      return Difficulty.mediu;
    case 'hard':
      return Difficulty.hard;
    default:
      throw ArgumentError('Invalid value for Difficulty: $value');
  }
}

Timestamp timeToTimestamp(Time time) {
  DateTime dateTime = DateTime(
    time.date.year,
    time.date.month,
    time.date.day,
    time.time.hour,
    time.time.minute,
  );

  return Timestamp.fromDate(dateTime);
}

Time timestampToTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  TimeOfDay time = TimeOfDay.fromDateTime(dateTime);
  return Time(date: dateTime, time: time);
}

Timestamp toTimestamp(DateTime dateTime, TimeOfDay timeOfDay) {
  DateTime date = DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );

  return Timestamp.fromDate(date);
}
