import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_key.dart';
import '../widgets/custom_nav_bar.dart';
import '../controllers/global_controller.dart';

class MapScreen extends StatefulWidget {
  final GeoPoint start;
  final GeoPoint end;

  MapScreen({Key? key, required this.start, required this.end})
      : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

  late LatLng sourceLocation;
  late LatLng destination;

  Set<Marker> markers = {};

  void init() {
    _locationController.onInit();

    sourceLocation = LatLng(
      widget.start.latitude,
      widget.start.longitude,
    );
    destination = LatLng(
      widget.end.latitude,
      widget.end.longitude,
    );

    markers.clear();
    markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: LatLng(sourceLocation.latitude, sourceLocation.longitude),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: LatLng(destination.latitude, destination.longitude),
      ),
    };
  }

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(widget.start.latitude, widget.start.longitude),
        PointLatLng(widget.end.latitude, widget.end.longitude),
        travelMode: TravelMode.walking);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
    getPolyPoints();
  }

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      _locationController.getLatitude(),
      _locationController.getLongitude(),
    ),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [sourceLocation, destination],
        color: Colors.blue,
        width: 5,
      ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Pathfinder')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                polylines: polylines,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController mapController) {
                  mapController = mapController;
                  getPolyPoints();
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
