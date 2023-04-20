import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/weather_data_daily.dart';
import '../utils/constant_colors.dart';

class DailyWeatherWidget extends StatelessWidget {
  final Daily daily;
  final int index;

  const DailyWeatherWidget({
    Key? key,
    required this.index,
    required this.daily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(daily.temp.toString(),
          style: const TextStyle(
              fontSize: 18.0, color: kLightColor, fontWeight: FontWeight.bold)),
    );
  }
}
