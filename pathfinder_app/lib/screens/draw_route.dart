// ignore_for_file: sdk_version_since, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../controllers/global_controller.dart';

class DrawMapScreen extends StatefulWidget {
  final List<LatLng> list;

  DrawMapScreen({Key? key, required this.list}) : super(key: key);

  @override
  State<DrawMapScreen> createState() => DrawMapScreenState();
}

class DrawMapScreenState extends State<DrawMapScreen> {
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};

  init() {
    _locationController.onInit();
  }

  @override
  void initState() {
    super.initState();
  }

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      widget.list[0].latitude,
      widget.list[0].longitude,
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
            children: [
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
    PolylineId polylineId = PolylineId('routee');

    Set<Polyline> polylines = {
      Polyline(
          polylineId: polylineId,
          points: widget.list,
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
}
