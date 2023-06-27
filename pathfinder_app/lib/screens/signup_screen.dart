import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/repositories/user_repository.dart';
import 'package:pathfinder_app/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/covert.dart';
import '../widgets/reusable_widget.dart';
import 'package:pathfinder_app/screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserRepository userRepository = UserRepository();
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
    if (_usernameTextController.text.isEmpty ||
        _emailTextController.text.isEmpty ||
        _passwordTextController.text.isEmpty ||
        _confirmPasswordTextController.text.isEmpty) {
      showValidationDialog(
        context,
        "Empty fields",
        "Please fill in all fields.",
      );
    } else if (!passwordConfirmed()) {
      showValidationDialog(
        context,
        "Signup failed",
        "Passwords don't match.",
      );
    } else if (!validateEmail(_emailTextController.text)) {
      showValidationDialog(
        context,
        "Signup failed",
        "Please enter a valid email address.",
      );
    } else if (!validatePassword(_passwordTextController.text)) {
      showValidationDialog(
        context,
        "Signup failed",
        "Password should contain at least 8 characters, including uppercase and lowercase letters, numbers, and special characters.",
      );
    } else {
      try {
        final QuerySnapshot usernameSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('username', isEqualTo: _usernameTextController.text)
            .limit(1)
            .get();

        final QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: _emailTextController.text)
            .limit(1)
            .get();

        if (usernameSnapshot.docs.isNotEmpty) {
          showValidationDialog(
            context,
            "Signup failed",
            "Username already exists.",
          );
        } else if (emailSnapshot.docs.isNotEmpty) {
          showValidationDialog(
            context,
            "Signup failed",
            "An account with this email already exists.",
          );
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );

          await userRepository.addUserDetails(
              _usernameTextController.text, _emailTextController.text);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (error) {
        showValidationDialog(
          context,
          "Signup failed",
          "An error occurred during sign up. Please try again.",
        );
      }
    }
  }

  bool validateEmail(String email) {
    // Email pattern: Valid format with @something.com
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    // Password pattern: At least 8 characters, including uppercase, lowercase, number, and special character
    RegExp passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
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
        ? MediaQuery.of(context).size.height * 0.7
        : MediaQuery.of(context).size.height * 0.7;

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
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
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
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    reusableNormalTextField(
                                        "Username",
                                        Icons.person_outline,
                                        _usernameTextController,
                                        true,
                                        (() {})),
                                    SizedBox(
                                      height: 20,
                                    ),
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
                                        (() {})),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    reusablePasswordTextField(
                                        "Confirm password",
                                        Icons.lock_outline,
                                        _confirmPasswordTextController,
                                        true,
                                        (() {})),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    loginButton(context, false, () {
                                      signUp();
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
            ],
          ),
        ));
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
