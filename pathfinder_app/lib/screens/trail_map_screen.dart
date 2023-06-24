// ignore_for_file: sdk_version_since, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathfinder_app/storage/firebase_storage.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../controllers/global_controller.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

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
  Set<Marker> markers = {};
  late List<LatLng> coordinates;
  late String routeName;

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
    // init();
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
    await downloadAndParseKmlFilee(widget.route);

    setState(() {});
  }

  Future<void> downloadAndParseKmlFilee(String filePath) async {
    final kmlFilePath = filePath;

    // Download the KML file from Firebase Storage
    final downloadUrl = await firebaseStorage.ref(kmlFilePath).getDownloadURL();

    final response = await http.get(Uri.parse(downloadUrl));
    final kmlContent = response.body;

    // Parse the KML file and extract the data
    final document = xml.XmlDocument.parse(kmlContent);

    final placemarkElement = document.findAllElements('Placemark').singleOrNull;
    if (placemarkElement != null) {
      final nameElement = placemarkElement.findElements('name').singleOrNull;
      final lineStringElement =
          placemarkElement.findElements('LineString').firstOrNull;
      final coordinatesElement =
          lineStringElement?.findElements('coordinates').firstOrNull;

      if (nameElement != null && coordinatesElement != null) {
        routeName = nameElement.text.trim();
        final coordinatesText = coordinatesElement.text;
        final coordinateValues = coordinatesText.trim().split(' ');

        for (final coordinateValue in coordinateValues) {
          final trimmedValue = coordinateValue.trim();
          if (trimmedValue.isNotEmpty) {
            final coordinateTokens = trimmedValue.split(',');

            if (coordinateTokens.length == 3) {
              final longitude = double.parse(coordinateTokens[0]);
              final latitude = double.parse(coordinateTokens[1]);

              polylineCoordinates.add(LatLng(latitude, longitude));
            }
          }
        }

        // Print or process the extracted data as needed
        print('Route Name: $routeName');
      }
    }
  }
}
