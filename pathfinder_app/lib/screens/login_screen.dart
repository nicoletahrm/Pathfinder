import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/forgot_password_screen.dart';
import 'package:pathfinder_app/screens/home_screen.dart';
import 'package:pathfinder_app/screens/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/covert.dart';
import '../widgets/reusable_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_dialog.dart';
import 'admin_screen.dart';

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

  // Future<void> main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var email = prefs.getString("email");
  //   print(email);
  //   runApp(MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: email == null
  //         ? LoginScreen()
  //         : email == 'admin@admin.com'
  //             ? AdminScreen()
  //             : HomeScreen(),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    //main();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: hexStringToColor("#ffffff"),
        body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
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
                        logo("assets/images/auth_cover.jpg"),
                        Container(
                          height: getHeight(),
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
                                  "Log In",
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      reusableNormalTextField(
                                          "E-mail",
                                          Icons.mail,
                                          _emailTextController,
                                          true,
                                          (() {})),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      reusablePasswordTextField(
                                        "Password",
                                        Icons.lock_outline,
                                        _passwordTextController,
                                        true,
                                        () {},
                                      ),
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
                                                                ForgotPasswordScreen()));
                                                  },
                                                  child: Text(
                                                    'Forgot password?',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: hexStringToColor(
                                                          "#44564a"),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ))
                                            ]),
                                      ),
                                      loginButton(context, true, login),
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
    if (isKeyboardVisible) {
      return MediaQuery.of(context).size.height * 0.5;
    }
    return MediaQuery.of(context).size.height * 0.7;
  }

  void login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", _emailTextController.text);

    if (_emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty) {
      CustomDialog.show(
        context,
        "Empty fields",
        "Please fill in all fields.",
      );
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      )
          .then((value) {
        final email = value.user?.email ?? '';
        if (email.toLowerCase() == 'admin@admin.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }).catchError((error) {
        CustomDialog.show(
          context,
          "Login failed",
          "Incorrect email or password.",
        );
      });
    }
  }
}
