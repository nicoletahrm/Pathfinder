import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/covert.dart';
import '../widgets/reusable_widget.dart';

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
    //try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailTextController.text.trim());
    // ignore: use_build_context_synchronously
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const AlertDialog(
    //         content: Text('Password reset link sent! Check your email.'),
    //       );
    //     });
    //} on FirebaseAuthException catch (ex) {
    // print(ex);
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(ex.message.toString()),
    //       );
    //     });
    //}
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
                  logo("assets/images/image4.jpg"),
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
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
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
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                reusableNormalTextField("E-mail", Icons.email,
                                    _emailTextController, (() {})),
                                const SizedBox(
                                  height: 20,
                                ),
                                resetPasswordButton(context, forgotPassword()),
                                Padding(
                                  padding: const EdgeInsets.all(0),
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
                                                          const LoginScreen()));
                                            },
                                            child: Text(
                                              'Log In',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color:
                                                    hexStringToColor("#44564a"),
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
