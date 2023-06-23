import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathfinder_app/screens/draw_route.dart';
import '../utils/covert.dart';
import '../widgets/custom_circular_progress_indicator.dart';
import '../controllers/global_controller.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final GlobalController _locationController =
      Get.put(GlobalController(), permanent: true);

  List<LatLng> _recordedCoordinates = [];
  List<Polyline> polylineCoordinates = [];
  bool _isRecordingCoordinates = false;

  init() {
    _locationController.onInit();
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
            Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DrawMapScreen(list: _recordedCoordinates)));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return hexStringToColor("#44564a");
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)))),
                    child: Text('see')))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRecordingCoordinates,
        child: Icon(_isRecordingCoordinates ? Icons.stop : Icons.play_arrow),
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
      //_recordedCoordinates.clear();
    });
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
}
