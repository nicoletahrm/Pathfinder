// ignore_for_file: avoid_print, library_private_types_in_public_api, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/forgot_password_screen.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pathfinder_app/screens/signup_screen.dart';
import 'package:pathfinder_app/utils/colors_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool isKeyboardOn = false;
  late double height;

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateField(String val, String field) {
    switch (field) {
      case 'Email':
        if (val.isEmpty) {
          setState(() {
            _errorMessage = '$field can not be empty';
          });
        } else if (!EmailValidator.validate(val, true)) {
          setState(() {
            _errorMessage = 'Invalid $field';
          });
        } else {
          setState(() {
            _errorMessage = '';
          });
        }
        break;
      case 'Password':
        if (val.isEmpty) {
          setState(() {
            _errorMessage = '$field can not be empty';
          });
        } else {
          setState(() {
            _errorMessage = '';
          });
        }
        break;
    }
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");
    print(email);
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? const LoginScreen() : const HomeScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    main();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: hexStringToColor("#44564a"),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: false,
          reverse: true,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: [
                      logo("assets/images/image4.jpg"),
                      Container(
                        height: getHeight(),
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    reusableTextField("E-mail", Icons.mail,
                                        false, _emailTextController, (() {
                                      validateField(
                                          _emailTextController.text, "Email");
                                    })),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    reusableTextField(
                                        "Password",
                                        Icons.lock_outline,
                                        true,
                                        _passwordTextController, (() {
                                      validateField(
                                          _passwordTextController.text,
                                          "Password");
                                    })),
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ForgotPasswordScreen()));
                                                },
                                                child: Text(
                                                  'Forgot password?',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: hexStringToColor(
                                                        "#44564a"),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ))
                                          ]),
                                    ),
                                    loginButton(context, true, () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString(
                                          "email", _emailTextController.text);
                                      try {
                                        FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text,
                                        )
                                            .then((value) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen()));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        showErrorMessage(e.code);
                                      }
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
            ),
          ],
        ),
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

  getHeight() {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (isKeyboardVisible) return MediaQuery.of(context).size.height * 0.7;
    return MediaQuery.of(context).size.height * 0.7;
  }
}
