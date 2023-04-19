import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../reusable_widgets/custom_nav_bar.dart';
import '../controllers/global_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

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
            _locationController.onInit();
            _mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(_locationController.getLatitude(),
                        _locationController.getLongitude()),
                    zoom: 15)));

            markers.clear();

            markers.add(Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(_locationController.getLatitude(),
                    _locationController.getLongitude())));
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar());
  }

  getLocation() {}
}
