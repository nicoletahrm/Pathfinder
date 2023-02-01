import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/signup_screen.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';

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
      body: Container(
          decoration: BoxDecoration(color: hexStringToColor("#fed8c3")),
          child: SingleChildScrollView(
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
    );
  }

  Row signupOption() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("Don't have account?", style: TextStyle(color: Colors.grey)),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignupScreen()));
        },
        child: const Text(
          " Sign up",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }
}
