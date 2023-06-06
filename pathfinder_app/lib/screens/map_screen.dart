// ignore_for_file: sdk_version_since, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/custom_nav_bar.dart';
import '../controllers/global_controller.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

class MapScreen extends StatefulWidget {
  final GeoPoint destination;
  final String route;

  MapScreen({Key? key, required this.destination, required this.route})
      : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

  late LatLng sourceLocation;
  late LatLng destination;
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};

  void init() {
    _locationController.onInit();

    destination = LatLng(
      widget.destination.latitude,
      widget.destination.longitude,
    );

    // markers.clear();
    // markers = {
    //   Marker(
    //     markerId: const MarkerId('destination'),
    //     position: LatLng(destination.latitude, destination.longitude),
    //   )
    // };
  }

  @override
  void initState() {
    super.initState();
    init();
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
              //markers: markers,
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void getPolyPoints() async {
    polylineCoordinates = await extractCoordinatesFromKmlFile(
        'assets/files/harta.kml', widget.route);

    setState(() {});
  }

  // Function to read the KML/KMZ file and extract coordinates
  Future<List<LatLng>> extractCoordinatesFromKmlFile(
      String filePath, String trailName) async {
    List<LatLng> coordinates = [];
    trailName = trailName.trim();

    try {
      final byteData = await rootBundle.load(filePath);
      final xmlString = utf8.decode(byteData.buffer.asUint8List());

      final document = xml.XmlDocument.parse(xmlString);
      final placemarkElements = document.findAllElements('Placemark');

      for (final placemarkElement in placemarkElements) {
        final nameElement = placemarkElement.findElements('name').single;
        final name = nameElement.text.trim();

        if (name == trailName) {
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
      }
    } catch (e) {
      print('Error extracting coordinates: $e');
    }

    return coordinates;
  }
}
