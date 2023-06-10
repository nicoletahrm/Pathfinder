import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/difficulty.dart';

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

convertTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedDateTime = DateFormat('dd-MM HH:mm').format(dateTime);

  String hour = formattedDateTime.split(' ')[1];

  return hour;
}

convertTimeToDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

  String date = formattedDateTime.split(' ')[0];

  return date;
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");

  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }

  return Color(int.parse(hexColor, radix: 16));
}
