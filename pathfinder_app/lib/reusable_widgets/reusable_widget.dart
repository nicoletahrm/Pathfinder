import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/profile/profile_screen.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';

import '../screens/map_screen.dart';

Transform logo(String imageName) {
  return Transform.translate(
      offset: const Offset(0, -360),
      child: Image.asset(
        imageName,
        scale: 4.5,
        width: double.infinity,
      ));
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, Function() onChanged) {
  return TextField(
    onChanged: onChanged(),
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    cursorHeight: 25,
    style: GoogleFonts.poppins(fontSize: 18),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black45,
      ),
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black45, fontSize: 18),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: hexStringToColor("#f0f3f1"),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container loginButton(BuildContext context, bool isLogin, Function onTop) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: ElevatedButton(
        onPressed: () {
          onTop();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return hexStringToColor("#44564a");
            }),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)))),
        child: Text(isLogin ? 'LOG IN' : 'SIGN UP',
            style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ));
}

Future<Position> _getCurrentLocation() async {
  bool serviceEnable = await Geolocator.isLocationServiceEnabled();

  if (serviceEnable) {
    return Future.error('Location services are disable.');
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permision are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permission.');
  }

  return await Geolocator.getCurrentPosition();
}

Container homeNavBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, -15),
          blurRadius: 20,
          color: const Color(0xFFDADADA).withOpacity(0.15),
        ),
      ],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    ),
    child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home_outlined,
                size: 30,
                color: Colors.black54,
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
            ),
            IconButton(
                icon: const Icon(
                  Icons.place_outlined,
                  size: 30,
                  color: Colors.black54,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MapScreen()));
                  //_getCurrentLocation();
                 // _liveLocation();
                }),
            IconButton(
              icon: const Icon(
                Icons.hiking_outlined,
                size: 30,
                color: Colors.black54,
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
            ),
            IconButton(
              icon: const Icon(
                Icons.perm_identity_outlined,
                size: 30,
                color: Colors.black54,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen())),
            ),
          ],
        )),
  );
}

Container resetPasswordButton(BuildContext context, Future onTop) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: ElevatedButton(
        onPressed: () {
          onTop;
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return hexStringToColor("#44564a");
            }),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)))),
        child: Text('Reset password',
            style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ));
}

Widget profileMenu(BuildContext context, String text, Function onTop) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: hexStringToColor('FFF5F6F9'),
      ),
      onPressed: () {
        onTop();
      },
      child: Row(
        children: [
          logo("assets/images/logo1.png"),
          const SizedBox(width: 20),
          Expanded(child: Text(text)),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
}
