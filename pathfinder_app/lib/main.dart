import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pathfinder_app/screens/admin_screen.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({required this.prefs});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark,
    );

    var email = prefs.getString("email");

    print(email);

    return MaterialApp(
      title: 'Pathfinder',
      home: email == null
          ? LoginScreen()
          : email == 'admin@admin.com'
              ? AdminScreen()
              : HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
