import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../models/weather_data_daily.dart';
import '../utils/constant_colors.dart';

class DailyWeatherWidget extends StatelessWidget {
  final Daily daily;
  final int index;
  final Widget date;

  const DailyWeatherWidget({
    Key? key,
    required this.index,
    required this.daily,
    required this.date,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    getWeatherIcon(daily.weather![0].icon!),
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${daily.temp!.min!.round() + 5}º',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: kLightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 4.0),
                    child: date,
                  ),
                ),
              ],
            )));
  }

  getWeatherIcon(String icon) {
    return 'assets/icons/$icon.png';
  }
}
