// ignore_for_file: deprecated_member_use, sdk_version_since
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

final firebaseStorage = FirebaseStorage.instance;

  Future<void> downloadAndParseKmlFilee(String filePath, List<LatLng> polylineCoordinates, String routeName) async {
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
      }
    }
  }
