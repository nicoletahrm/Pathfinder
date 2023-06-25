import 'package:flutter/material.dart';
import '../models/trail_request.dart';
import '../repositories/request_repository.dart';
import '../widgets/custom_circular_progress_indicator.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final RequestRepository requestRepository = RequestRepository();
  late List<TrailRequest> requests;

  Future<void> init() async {
    requests = await requestRepository.getRequests();
  }

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
          return Text('Failed to initialize screen: ${snapshot.error}');
        } else {
          return buildTrail(context);
        }
      },
    );
  }

  Widget buildTrail(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return ListTile(
            title: Text(request.title),
            subtitle: Text(request.file),
            onTap: () {
              // Handle the tap event for a request
              print('Clicked on: ${request.title}');
            },
          );
        },
      ),
    );
  }
}

class Request {
  final String title;
  final String file;

  Request({required this.title, required this.file});
}
