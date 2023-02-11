import 'package:flutter/material.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pathfinder_app/screens/home_screen.dart';

import 'package:fluttericon/iconic_icons.dart';

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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
            ),
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen())),
            ),
          ],
        )),
  );
}






// Container uploadImage(BuildContext context, Function onTop) {
//   return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 60,
//       margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
//       child: ElevatedButton(
//         onPressed: () {
//           onTop();
//         },
//         style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.resolveWith((states) {
//               if (states.contains(MaterialState.pressed)) {
//                 return Colors.black26;
//               }
//               return hexStringToColor("#fed8c3");
//             }),
//             shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0)))),
//         child: IconButton(
//           icon: const Icon(Icons.image),
//           onPressed: () {},
//         ),
//       ));
// }

