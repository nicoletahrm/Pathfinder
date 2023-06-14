import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
    );

    return MaterialApp(
      title: 'Pathfinder',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
