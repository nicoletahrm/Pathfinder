import 'dart:convert';
import '../api/api_key.dart';
import '../models/weather_data_daily.dart';
import 'package:http/http.dart' as http;

class WeatherController {
  Future<List<Daily>> getWeatherData(double lat, double lon) async {
    WeatherDataDaily? weatherData;

    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);

    weatherData = WeatherDataDaily.fromJson(jsonString);

    return weatherData.daily;
  }

  String apiURL(var lat, var lon) {
    String url;

    url =
        "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey&exclude=minutely&units=metric";

    return url;
  }
}
