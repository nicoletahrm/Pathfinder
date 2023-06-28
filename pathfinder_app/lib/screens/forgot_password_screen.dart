import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/covert.dart';
import '../widgets/reusable_widget.dart';
import '../widgets/custom_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  Future forgotPassword() async {
    final String email = _emailTextController.text.trim();

    if (email.isEmpty) {
      CustomDialog.show(
        context,
        "Validation Error",
        "Please enter your email address.",
      );
      return;
    }

    if (!isEmailValid(email)) {
      CustomDialog.show(
        context,
        "Validation Error",
        "Please enter a valid email address.",
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      CustomDialog.show(
        context,
        "Email Sent",
        "Password reset link sent! Check your email.",
      );
    } catch (error) {
      String errorMessage = 'An error occurred. Please try again later.';

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          errorMessage = 'No user found with the provided email.';
        }
      }

      showValidationDialog(context, "Fail", errorMessage);
    }
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: hexStringToColor("#ffffff"),
        body: ListView(
          shrinkWrap: false,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    logo("assets/images/auth_cover.jpg"),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: hexStringToColor("#ffffff"),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Forgot password",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: hexStringToColor("#44564a"),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reusableNormalTextField("E-mail", Icons.email,
                                      _emailTextController, true, (() {})),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  resetPasswordButton(context, forgotPassword),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              },
                                              child: Text(
                                                'Log In',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  color: hexStringToColor(
                                                      "#44564a"),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))
                                        ]),
                                  ),
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
