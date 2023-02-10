// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pathfinder_app/screens/signup_screen.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reusable_widgets/reusable_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

 String _errorMessage = "";

 void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: hexStringToColor("#44564a"),
      body: ListView(
        shrinkWrap: false,
        reverse: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  logo("assets/images/logo1.png"),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
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
                            "Log In",
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
                                reusableTextField("E-mail", Icons.mail, false,
                                    _emailTextController),

                                const SizedBox(
                                  height: 20,
                                ),
                                reusableTextField(
                                    "Password",
                                    Icons.lock_outline,
                                    true,
                                    _passwordTextController),
                                const SizedBox(
                                  height: 20,
                                ),
                                loginButton(context, true, () {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  )
                                      .then((value) {
                                    print("Sign in.");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()));
                                  });
                                }),
                                signUpOption(true),
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
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
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