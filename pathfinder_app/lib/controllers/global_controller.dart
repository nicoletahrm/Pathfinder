import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../api/api_key.dart';
import '../models/weather_data_daily.dart';
import 'package:http/http.dart' as http;

class GlobalController {
  late double _latitude = 0.0;
  late double _longitude = 0.0;

  double getLatitude() => _latitude;
  double getLongitude() => _longitude;

  onInit() {
    getLocation();
  }

  getLocation() async {
    bool isServiceEnable;
    LocationPermission locationPermission;

    isServiceEnable = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnable) {
      return Future.error("Location not enable");
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location permission are denied forever.");
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied.");
      }
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      _latitude = value.latitude;
      _longitude = value.longitude;
    });
  }

  Future<List<Daily>> getWeatherByLatAndLon(double lat, double lon) async {
    var weatherData = await getWeatherData(lat, lon);
    return weatherData.daily;
  }

  Future<WeatherDataDaily> getWeatherData(double lat, double lon) async {
    WeatherDataDaily? weatherData;

    var response = await http.get(Uri.parse(apiURL(lat, lon)));
    var jsonString = jsonDecode(response.body);

    weatherData = WeatherDataDaily.fromJson(jsonString);

    return weatherData;
  }

  String apiURL(var lat, var lon) {
    String url;

    url =
        "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey&exclude=minutely&units=metric";
    return url;
  }
}
