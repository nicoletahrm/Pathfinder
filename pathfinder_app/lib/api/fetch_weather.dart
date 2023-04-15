import 'dart:convert';

import 'package:pathfinder_app/api/api_key.dart';
import 'package:pathfinder_app/models/weather_model.dart';

import '../models/weather_data.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class FetchWeatherAPI {
  WeatherData? weatherData;

  Future<WeatherData?> processData(lat, lon) async {
    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);
    weatherData = WeatherData(WeatherDataCurrent.fromJson(jsonString));
    return weatherData;
  }
}

String apiURL(var lat, var lon) {
  String url;

  url =
      "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey&exclude=minutely";
  return url;
}
