import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark, // or light
    );

    return MaterialApp(
      title: 'Pathfinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
  //);}
}
