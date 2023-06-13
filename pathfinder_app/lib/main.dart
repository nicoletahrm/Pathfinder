import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var email = prefs.getString("email");

  runApp(MaterialApp(
    home: email == null ? LoginScreen() : HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
    );

    return MaterialApp();
  }
}
