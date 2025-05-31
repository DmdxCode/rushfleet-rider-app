// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rushfleet_rider/components/login_textfield.dart';
import 'package:rushfleet_rider/components/my_buttons.dart';
import 'package:rushfleet_rider/components/password_textfield.dart';
import 'package:rushfleet_rider/components/rushfleet_logo.dart';
import 'package:rushfleet_rider/components/sign_in_alert_dialog.dart';
import 'package:rushfleet_rider/pages/registration_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailregcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  Future<void> signUpAndSendVerification() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: Color(0xFF12AA6C)),
        );
      },
    );
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailregcontroller.text,
            password: _passwordcontroller.text,
          );
      User? user = userCredential.user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationForm(user: user!)),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e);
    }
    // if (_emailregcontroller.text.isEmpty) {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return RushFleetAlertDialog(
    //         title: 'Empty Input',
    //         message: 'Please fill in the fields',
    //         confirmText: 'Ok',
    //         onConfirm: () {
    //           Navigator.pop(context);
    //         },
    //       );
    //     },
    //   );
    // }
  }

  void showErrorMessage(FirebaseException e) {
    String message = (e.code);

    if (e.code == 'invalid-email') {
      message = "The email address is not valid";
    } else if (e.code == 'user-disabled') {
      message = "This user account has been disabled";
    } else if (e.code == 'user-not-found') {
      message = "No user found for this email";
    } else if (e.code == 'wrong-password') {
      message = "Incorrect password. Please try again";
    } else if (e.code == 'too-many-requests') {
      message = "Too many attempts. Try again later";
    } else if (e.code == 'network-request-failed') {
      message = "No internet connection. Please check your network";
    } else if (e.code == 'weak-password') {
      message = "Weak password";
    } else if (e.code == 'email-already-in-use') {
      message = "Email already in use";
    }
    showDialog(
      context: context,
      builder: (context) {
        return SignInAlertDialog(
          message: message,
          confirmText: 'Ok',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061F16),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400, // Set the maximum width
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    RushfleetLogo(),
                    const SizedBox(height: 80),
                    Column(
                      children: [
                        Text(
                          "Register with RushFleet",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Enter your email to create an account",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 40),
                        LoginTextfield(
                          controller: _emailregcontroller,
                          icon: Icons.mail_rounded,
                          hintText: "Email",
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 20),
                        PasswordTextfield(
                          controller: _passwordcontroller,
                          icon: Icons.lock,
                          hintText: "Password",
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 50),
                        MyButtons(
                          text: "Continue",
                          color: Color(0xFF12AA6C),
                          fontcolor: Colors.white,
                          border: Border(),
                          onTap: signUpAndSendVerification,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "By continuing, you agree to our Privacy Policy and our Terms of Service",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
