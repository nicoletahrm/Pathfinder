import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: hexStringToColor("#fed8c3"),
      body: ListView(
        //padding: const EdgeInsets.fromLTRB(0, 400, 0, 0),
        shrinkWrap: false,
        reverse: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  logo("assets/images/logo.png"),
                  Container(
                    height: 535,
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
                                reusableTextField(
                                    "Username",
                                    Icons.person_outline,
                                    false,
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
                                loginButton(context, true, () {}),
                                const SizedBox(
                                  height: 100,
                                ),
                                signUpOption(),
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

  Row signUpOption() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Don't have an account?",
          style: GoogleFonts.poppins(
              fontSize: 15, color: hexStringToColor("#44564a"))),
      GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupScreen()));
          },
          child: Text(
            " Sign up",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: hexStringToColor("#44564a"),
              fontWeight: FontWeight.bold,
            ),
          ))
    ]);
  }
}
