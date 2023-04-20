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
    return Container(
        padding:
            const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
        child: GlassmorphicContainer(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 90.0,
            width: 90.0,
            blur: -1.0,
            border: 0.0,
            borderRadius: 7.0,
            alignment: Alignment.center,
            linearGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kLightColor.withOpacity(0.4),
                kLightColor.withOpacity(0.4),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kLightColor.withOpacity(0.4),
                kLightColor.withOpacity(0.4),
              ],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text('${daily.temp!.max!.round()}º',
                  style: const TextStyle(
                      fontSize: 20.0,
                      color: kLightColor,
                      fontWeight: FontWeight.bold)),
            )));
  }
}
