import 'package:flutter/material.dart';
import 'package:pathfinder_app/models/weather_data_daily.dart';

class DailyForecastWidget extends StatefulWidget {
  final WeatherDataDaily weatherDataDaily;
  const DailyForecastWidget({super.key, required this.weatherDataDaily});

  @override
  State<DailyForecastWidget> createState() => _DailyForecastWidget();
}

class _DailyForecastWidget extends State<DailyForecastWidget> {



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
