// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:pathfinder_app/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  late double height;

  @override
  void dispose() {
    _usernameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      //add user details
      addUserDetails(_usernameTextController.text, _emailTextController.text);
    }
  }

  Future addUserDetails(String username, String email) async {
    await FirebaseFirestore.instance.collection("user").add({
      'username': username,
      'email': email,
    });
  }

  bool passwordConfirmed() {
    if (_passwordTextController.text == _confirmPasswordTextController.text) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    height = isKeyboardVisible
        ? MediaQuery.of(context).size.height * 0.8
        : MediaQuery.of(context).size.height * 0.7;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: hexStringToColor("#44564a"),
      body: ListView(
        shrinkWrap: false,
        reverse: true,
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: (MediaQuery.of(context).viewInsets.bottom)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    logo("assets/images/image4.jpg"),
                    Container(
                      height: height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: hexStringToColor("#ffffff"),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign Up",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: hexStringToColor("#44564a"),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reusableTextField(
                                      "Username",
                                      Icons.person_outline,
                                      false,
                                      _usernameTextController,
                                      (() {})),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  reusableTextField("E-mail", Icons.mail, false,
                                      _emailTextController, (() {})),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  reusableTextField(
                                      "Password",
                                      Icons.lock_outline,
                                      true,
                                      _passwordTextController,
                                      (() {})),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  reusableTextField(
                                      "Confirm password",
                                      Icons.lock_outline,
                                      true,
                                      _confirmPasswordTextController,
                                      (() {})),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  loginButton(context, false, () {
                                    signUp().then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen())));
                                  }),
                                  signUpOption(false),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row signUpOption(bool isLogin) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(isLogin ? "Don't have an account? " : "Already have an account? ",
          style: GoogleFonts.poppins(
              fontSize: 15, color: hexStringToColor("#44564a"))),
      GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: Text(
            isLogin ? 'Sign Up' : 'Log In',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: hexStringToColor("#44564a"),
              fontWeight: FontWeight.bold,
            ),
          ))
    ]);
  }
}
