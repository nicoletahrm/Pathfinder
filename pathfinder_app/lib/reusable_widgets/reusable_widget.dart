import 'package:flutter/material.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';
import 'package:google_fonts/google_fonts.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 160,
    height: 340,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    //style: const TextStyle(color: Colors.black, fontSize: 18),
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
      fillColor: Colors.white.withOpacity(0.9),
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
      child: ElevatedButton(
        onPressed: () {
          onTop();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return hexStringToColor("#8d8d8d");
            }),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)))),
        child: Text(isLogin ? 'LOG IN' : 'SIGN UP',
            style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ));
}
