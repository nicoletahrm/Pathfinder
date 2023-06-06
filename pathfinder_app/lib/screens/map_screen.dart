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
    PolylineId polylineId = PolylineId('route');

    Set<Polyline> polylines = {
      Polyline(
          polylineId: polylineId,
          points: polylineCoordinates,
          color: Colors.blue,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap),
    };

    return Scaffold(
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
        'assets/files/harta.kml', 'Valea Glăjărie - Cabana Malaiesti');

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

        print("NAME: " + name);
        print("TRIAL NAME: " + trailName);
        print(name == trailName);

        if (name == trailName) {
          print('blablabla');

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

    print(coordinates.toString());

    return coordinates;
  }
}
