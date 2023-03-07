import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../reusable_widgets/nav_bar.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController mapController) {
            _mapController = mapController;
            position();
          },
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () async {
        //     Position position = await _getCurrentLocation();

        //     _mapController.animateCamera(CameraUpdate.newCameraPosition(
        //         CameraPosition(
        //             target: LatLng(position.latitude, position.longitude))));

        //     markers.clear();

        //     markers.add(Marker(
        //         markerId: const MarkerId('currentLocation'),
        //         position: LatLng(position.latitude, position.longitude)));

        //     setState(() {});
        //   },
        //   label: const Text('Current location'),
        //   icon: const Icon(Icons.location_history),
        // ),
        bottomNavigationBar: const CustomBottomNavBar());
  }

  void position() async {
    Position position = await _getCurrentLocation();

    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude))));

    markers.clear();

    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude)));
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();

    if (serviceEnable) {
      return Future.error('Location services are disable.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permision are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permission.');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
