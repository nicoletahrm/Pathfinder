import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/covert.dart';
import '../utils/fonts.dart';

Widget logo(String imageName) {
  return Transform.translate(
      offset: Offset(0, -400),
      child: Image.asset(
        imageName,
        scale: 2.0,
        width: double.infinity,
      ));
}

TextField reusablePasswordTextField(
    String text, IconData icon, TextEditingController controller, onChanged()) {
  return TextField(
      onChanged: onChanged(),
      controller: controller,
      obscureText: true,
      cursorColor: Colors.black,
      cursorHeight: 25,
      style: GoogleFonts.poppins(fontSize: 18),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black45,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.black45, fontSize: 18),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: hexStringToColor("#f0f3f1"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
      keyboardType: TextInputType.visiblePassword);
}

TextField reusableNormalTextField(
    String text, IconData icon, TextEditingController controller, onChanged()) {
  return TextField(
    onChanged: onChanged(),
    controller: controller,
    cursorColor: Colors.black,
    cursorHeight: 25,
    style: GoogleFonts.poppins(fontSize: 18),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black45,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black45, fontSize: 18),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: hexStringToColor("#f0f3f1"),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: TextInputType.emailAddress,
  );
}

Container loginButton(BuildContext context, bool isLogin, Function onTop) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
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

void showValidationDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return showValidationDialogWidget(context, title, content);
    },
  );
}

Dialog showValidationDialogWidget(context, String title, String content) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: darkBoldFont),
          SizedBox(height: 10),
          Text(content, style: normalFont),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text(
              "OK",
              style: boldFont,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: hexStringToColor("#44564a"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Container resetPasswordButton(BuildContext context, Function onPressed) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
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
        child: Text('Reset password', style: darkBoldFont),
      ));
}

Widget profileMenu(BuildContext context, String text, Function onTop) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          SizedBox(width: 20),
          Expanded(child: Text(text)),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    ),
  );
}

TextField textField(String text, TextEditingController controller, onChanged) {
  return TextField(
    onChanged: onChanged(),
    controller: controller,
    cursorColor: Colors.black,
    cursorHeight: 25,
    style: GoogleFonts.poppins(fontSize: 18),
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.black45, fontSize: 18),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: hexStringToColor("#f0f3f1"),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 0, style: BorderStyle.none)),
    ),
  );
}
