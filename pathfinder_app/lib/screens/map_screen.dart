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
  //late GoogleMapController _mapController;
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

  init() {
    _locationController.onInit();

    markers.clear();

    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(_locationController.getLatitude(),
            _locationController.getLongitude())));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  late CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(_locationController.getLatitude(),
          _locationController.getLongitude()),
      zoom: 15);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          //markers: markers,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController mapController) {
            //_mapController = mapController;
          },
          myLocationEnabled: true,
        ),
        bottomNavigationBar: const CustomBottomNavBar());
  }
}
