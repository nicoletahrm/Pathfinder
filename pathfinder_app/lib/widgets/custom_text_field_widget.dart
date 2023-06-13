// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/covert.dart';

class CustomTextField extends StatefulWidget {
  String text;
  IconData icon;
  bool isPasswordType;
  TextEditingController controller;
  dynamic onChanged;

  CustomTextField(
      {super.key,
      required this.text,
      required this.icon,
      required this.isPasswordType,
      required this.controller,
      required this.onChanged});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged(),
      controller: widget.controller,
      obscureText: widget.isPasswordType,
      enableSuggestions: !widget.isPasswordType,
      autocorrect: !widget.isPasswordType,
      cursorColor: Colors.black,
      cursorHeight: 25,
      style: GoogleFonts.poppins(fontSize: 18),
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Colors.black45,
        ),
        labelText: widget.text,
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 18),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: hexStringToColor("#f0f3f1"),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: widget.isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }
}
