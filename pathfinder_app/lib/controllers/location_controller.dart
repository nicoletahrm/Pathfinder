import 'package:geolocator/geolocator.dart';

class LocationController {
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
}
