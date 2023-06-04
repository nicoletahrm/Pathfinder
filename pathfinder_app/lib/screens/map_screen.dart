import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:pathfinder_app/widgets/reusable_widget.dart';
import '../widgets/custom_nav_bar.dart';
import '../controllers/global_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);
  // final TextEditingController _searchTextFieldController =
  //     TextEditingController();

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
      appBar: AppBar(title: Text('Pathfinder')),
      body: SafeArea(
        child: Column(
          children: [
            // reusableTextField(
            //   'Search...',
            //   Icons.search,
            //   false,
            //   _searchTextFieldController,
            //   (() {}),
            // ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                //markers: markers,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  mapController = _locationController as GoogleMapController;
                },
                myLocationEnabled: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
