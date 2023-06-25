import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/admin_screen.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading screen if SharedPreferences is still loading
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error if SharedPreferences fails to load
          return Text('Error loading SharedPreferences: ${snapshot.error}');
        } else {
          // SharedPreferences loaded successfully
          final prefs = snapshot.data!;
          final email = prefs.getString("email");

          print(email);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: email == null
                ? LoginScreen()
                : email.toLowerCase() == 'admin@admin.com'
                    ? AdminScreen()
                    : LoginScreen(),
          );
        }
      },
    );
  }
}
