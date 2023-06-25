// ignore_for_file: sdk_version_since, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathfinder_app/storage/firebase_storage.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../controllers/global_controller.dart';

class TrailMapScreen extends StatefulWidget {
  final GeoPoint destination;
  final String route;

  TrailMapScreen({Key? key, required this.destination, required this.route})
      : super(key: key);

  @override
  State<TrailMapScreen> createState() => TrailMapScreenState();
}

class TrailMapScreenState extends State<TrailMapScreen> {
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

  late LatLng sourceLocation;
  late LatLng destination;
  List<LatLng> polylineCoordinates = [];
  late String routeName = '';

  init() {
    _locationController.onInit();

    destination = LatLng(
      widget.destination.latitude,
      widget.destination.longitude,
    );
  }

  @override
  void initState() {
    super.initState();
    getPolyPoints();
  }

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      widget.destination.latitude,
      widget.destination.longitude,
    ),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CustomCircularProgressIndicator(),
            ],
          ));
        } else if (snapshot.hasError) {
          return Text('Failed to initialize route: ${snapshot.error}');
        } else {
          return buildRoute(context);
        }
      },
    );
  }

  Widget buildRoute(BuildContext context) {
    PolylineId polylineId = PolylineId('route');

    Set<Polyline> polylines = {
      Polyline(
          polylineId: polylineId,
          points: polylineCoordinates,
          color: Colors.pink,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap),
    };

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              polylines: polylines,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController mapController) {
                mapController = mapController;
              },
              myLocationEnabled: true,
            ),
            Positioned(
              top: 30.0,
              left: 28.0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPolyPoints() async {
    await downloadAndParseKmlFilee(
        widget.route, polylineCoordinates, routeName);

    setState(() {});
  }
}
