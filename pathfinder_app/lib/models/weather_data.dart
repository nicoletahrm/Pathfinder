import 'package:pathfinder_app/models/weather_data_daily.dart';

class WeatherData {
  final WeatherDataDaily? daily;

  WeatherData(this.daily);

  WeatherDataDaily? getWeatherDataDaily() => daily;
}
