import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pathfinder_app/screens/record_route_screen.dart';
import '../controllers/location_controller.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import 'package:xml/xml.dart' as xml;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MapScreen extends StatefulWidget {
  final String fileName;

  MapScreen({Key? key, required this.fileName}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final LocationController _locationController =
      Get.put(LocationController(), permanent: true);
  final firebaseStorage = firebase_storage.FirebaseStorage.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  List<LatLng> _recordedCoordinates = [];
  List<Polyline> polylineCoordinates = [];
  bool _isRecordingCoordinates = false;

  init() {
    _locationController.onInit();
    main();
  }

  @override
  void initState() {
    super.initState();
  }

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
        _locationController.getLatitude(), _locationController.getLongitude()),
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
    Set<Polyline> polylines = Set.from(polylineCoordinates);

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
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: ElevatedButton(
                    onPressed: _toggleRecordingCoordinates,
                    child: Icon(
                      _isRecordingCoordinates ? Icons.stop : Icons.play_arrow,
                      size: 32,
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRecordingCoordinates() {
    setState(() {
      _isRecordingCoordinates = !_isRecordingCoordinates;
      if (_isRecordingCoordinates) {
        _startRecordingCoordinates();
      } else {
        _stopRecordingCoordinates();
      }
    });
  }

  void _startRecordingCoordinates() {
    polylineCoordinates.clear();
    _getUserLocation();
  }

  void _stopRecordingCoordinates() {
    PolylineId polylineId = PolylineId('route');
    Polyline polyline = Polyline(
      polylineId: polylineId,
      points: _recordedCoordinates,
      color: Colors.pink,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    print(_recordedCoordinates);

    setState(() {
      polylineCoordinates.add(polyline);
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecordRouteScreen(
                email: currentUser!.email!,
                fileName: widget.fileName,
                list: _recordedCoordinates)));
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng userLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      _recordedCoordinates.add(userLocation);
    });

    if (_isRecordingCoordinates) {
      _getUserLocation();
    }
  }

  String generateKmlContent(List<LatLng> points, String routeName) {
    final builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('kml', nest: () {
      builder.attribute('xmlns', 'http://www.opengis.net/kml/2.2');
      builder.element('Document', nest: () {
        builder.element('Placemark', nest: () {
          builder.element('name', nest: () {
            builder.text(routeName);
          });
          builder.element('LineString', nest: () {
            builder.element('coordinates', nest: () {
              final coordinates = points
                  .map((point) => '${point.longitude},${point.latitude},0');
              builder.text(coordinates.join(' '));
            });
          });
        });
      });
    });

    final xmlDoc = builder.buildDocument();
    return xmlDoc.toString();
  }

  Future<String> getTemporaryFilePath() async {
    final directory = await getTemporaryDirectory();
    String file = widget.fileName;
    return directory.path + '/$file';
  }

  Future<void> saveKmlFile(String kmlContent, String filePath) async {
    final file = File(filePath);
    await file.writeAsString(kmlContent);
  }

  void main() async {
    final kmlContent = generateKmlContent(_recordedCoordinates, 'My route');
    final filePath = await getTemporaryFilePath();
    await saveKmlFile(kmlContent, filePath);

    await firebaseStorage
        .ref(filePath)
        .putString(kmlContent, format: firebase_storage.PutStringFormat.raw);
  }
}
