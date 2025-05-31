// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:rushfleet_rider/components/login_textfield.dart';
import 'package:rushfleet_rider/components/my_buttons.dart';
import 'package:rushfleet_rider/components/rushfleet_logo.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rushfleet_rider/pages/success_verification_page.dart';

class RegistrationForm extends StatefulWidget {
  final User user;
  const RegistrationForm({super.key, required this.user});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? verificationId;
  int balance = 0;

  Future<void> registerUser() async {
    String firstName = _firstnameController.text.trim();
    String lastName = _lastnameController.text.trim();
    String phone = _phoneController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: Color(0xFF12AA6C)),
        );
      },
    );

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter all details")));
      return;
    }

    try {
      await _firestore.collection("riders").doc(widget.user.uid).set({
        "rider_id": widget.user.uid,
        "first_name": _firstnameController.text,
        "last_name": _lastnameController.text,
        "rider_number": phone,
        "email": widget.user.email,
        "rider_wallet_balance": balance,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await widget.user.updateDisplayName(firstName);
      await widget.user.reload();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessVerificationPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Center(child: Text(message)));
      },
    );
  }

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061F16),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400, // Set the maximum width
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      RushfleetLogo(),
                      const SizedBox(height: 80),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Register with RushFleet",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "Continue creating account with ",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                          children: [
                            TextSpan(
                              text: user?.email ?? "No email available",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      LoginTextfield(
                        controller: _firstnameController,
                        icon: Icons.person,
                        hintText: "First Name",
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      LoginTextfield(
                        controller: _lastnameController,
                        icon: Icons.person,
                        hintText: "Last Name",
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      IntlPhoneField(
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        cursorHeight: 15,
                        flagsButtonPadding: EdgeInsets.symmetric(vertical: 0.5),
                        style: TextStyle(color: Colors.white, fontSize: 15),

                        dropdownTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        pickerDialogStyle: PickerDialogStyle(
                          listTileDivider: SizedBox(),
                          backgroundColor: Color(0xffD4E9E2),
                        ),
                        controller: _phoneController,

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 12),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF12AA6C),
                              width: 0.5,
                            ), // Normal bottom border
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF12AA6C),
                              width: 0.5,
                            ), // Highlighted bottom border when focused
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF12AA6C),
                              width: 0.5,
                            ), // Bottom border when there's an error
                          ),
                        ),
                        initialCountryCode:
                            'NG', // Set the default country (Qatar)
                        onChanged: (phone) {
                          // print(
                          //     'Phone Number: ${phone.completeNumber}'); // Full number with country code
                        },
                        onCountryChanged: (country) {
                          // print('Country changed to: ${country.name}');
                        },
                      ),
                      const SizedBox(height: 40),
                      MyButtons(
                        text: "Continue",
                        color: const Color(0xFF12AA6C),
                        fontcolor: Colors.white,
                        border: Border(),
                        onTap: registerUser,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "By continuing, you agree to our Privacy Policy and our Terms of Service",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
