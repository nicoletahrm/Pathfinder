import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Time {
  late final DateTime date;
  late final TimeOfDay time;

  Time({
    required this.date,
    required this.time,
  });

  String getDateWithoutTime() {
    final localDateTime = date.toLocal();
    final formattedDate = DateFormat('dd-MM-yyyy').format(localDateTime);
    return formattedDate;
  }

  String getFormattedTime() {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
