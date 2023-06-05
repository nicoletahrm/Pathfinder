// ignore_for_file: sdk_version_since

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/api_key.dart';
import '../widgets/custom_nav_bar.dart';
import '../controllers/global_controller.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

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
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
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
      )
    };
  }

  @override
  void initState() {
    super.initState();
    init();
    getPolyPoints();
  }

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      widget.start.latitude,
      widget.start.longitude,
    ),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    Set<Polyline> polylines = {
      Polyline(
        polylineId: PolylineId('route'),
        points: [
          LatLng(45.4941053, 25.4744011),
          LatLng(45.4929622, 25.4737145),
          LatLng(45.4916987, 25.4740578),
          LatLng(45.4904953, 25.4731137),
          LatLng(45.488991, 25.4737145),
          LatLng(45.4881486, 25.474487),
          LatLng(45.4877274, 25.474487),
          LatLng(45.4876071, 25.4751736),
          LatLng(45.4863434, 25.4754311),
          LatLng(45.4859824, 25.4748303),
          LatLng(45.4828532, 25.4738861),
          LatLng(45.482432, 25.4747445),
          LatLng(45.4814691, 25.4751736),
          LatLng(45.4808071, 25.4761177),
          LatLng(45.4799044, 25.4748303),
          LatLng(45.480446, 25.4732853),
          LatLng(45.4803257, 25.472427),
          LatLng(45.4795433, 25.472427),
          LatLng(45.4796035, 25.4714829),
          LatLng(45.4782193, 25.4718262),
          LatLng(45.4772564, 25.4697663),
          LatLng(45.4762934, 25.4698521),
          LatLng(45.472923, 25.4627282),
          LatLng(45.47196, 25.4624707),
          LatLng(45.471659, 25.4614407),
          LatLng(45.4700941, 25.4615265),
          LatLng(45.4702145, 25.4601532),
          LatLng(45.469131, 25.4593808),
          LatLng(45.4664825, 25.4568058),
          LatLng(45.4664825, 25.4559475),
          LatLng(45.4670242, 25.4549176),
          LatLng(45.4658805, 25.4535443)
        ],
        color: Colors.pink,
        width: 6,
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

  void getPolyPoints() async {
    polylineCoordinates = await extractCoordinatesFromKmlFile(
      'assets/images/cabana_malaiesti.kml',
    );

    if (polylineCoordinates.isNotEmpty) {
      polylineCoordinates.forEach((LatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // polylineCoordinates = await extractCoordinatesFromKmlFile(
    //   'assets/images/cabana_malaiesti.kml',
    // );

    setState(() {});
  }

  // Function to read the KML/KMZ file and extract coordinates
  Future<List<LatLng>> extractCoordinatesFromKmlFile(String filePath) async {
    List<LatLng> coordinates = [];

    try {
      final byteData = await rootBundle.load(filePath);
      final xmlString = utf8.decode(byteData.buffer.asUint8List());

      final document = xml.XmlDocument.parse(xmlString);
      final placemarkElements = document.findAllElements('Placemark');

      for (final placemarkElement in placemarkElements) {
        final lineStringElement =
            placemarkElement.findElements('LineString').firstOrNull;
        final coordinatesElement =
            lineStringElement?.findElements('coordinates').firstOrNull;

        if (coordinatesElement != null) {
          final coordinatesText = coordinatesElement.text;
          final coordinateValues = coordinatesText.trim().split('\n');

          for (final coordinateValue in coordinateValues) {
            final trimmedValue = coordinateValue.trim();
            if (trimmedValue.isNotEmpty) {
              final coordinateTokens = trimmedValue.split(',');

              if (coordinateTokens.length == 3) {
                final longitude = double.parse(coordinateTokens[0]);
                final latitude = double.parse(coordinateTokens[1]);

                coordinates.add(LatLng(latitude, longitude));
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error extracting coordinates: $e');
    }

    print("POLYLINES: " + coordinates.toString());

    return coordinates;
  }
}
