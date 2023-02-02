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
        backgroundColor: hexStringToColor("#fed8c3"),
        body: SafeArea(
          //decoration: BoxDecoration(color: hexStringToColor("#fed8c3")),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                reusableTextField("Username", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                loginButton(context, true, () {}),
                signupOption()
              ],
            ),
          )),
        ));
  }

  Row signupOption() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Don't have an account?",
          style: GoogleFonts.poppins(
              fontSize: 18, color: hexStringToColor("#8d8d8d"))),
      GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupScreen()));
          },
          child: Text(
            " Sign up",
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: hexStringToColor("#44564a"),
            ),
          ))
    ]);
  }
}
