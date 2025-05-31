import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rushfleet_rider/components/login_textfield2.dart';
import 'package:rushfleet_rider/components/my_buttons.dart';
import 'package:rushfleet_rider/components/rushfleet_alert_dialog.dart';
import 'package:rushfleet_rider/pages/intro_page.dart';

class RiderProfilePage extends StatefulWidget {
  const RiderProfilePage({super.key});

  @override
  State<RiderProfilePage> createState() => _RiderProfilePageState();
}

class _RiderProfilePageState extends State<RiderProfilePage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // File? _image;
  final picker = ImagePicker();
  String? profileImageUrl; // Store profile image URL
  String? firstname;
  String? secondname;
  String? phoneNumber;
  String? email;

  @override
  void initState() {
    super.initState();
    // loadProfilePicture();
    getUsername();
  }

  Future<void> changePassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: Color(0xFF12AA6C)),
        );
      },
    );

    User? user = _auth.currentUser;

    if (user != null) {
      String currentPassword = _currentPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return RushFleetAlertDialog(
              title: 'lib/images/delete.png',
              message: "New passwords don't match!",
              confirmText: "Ok",
              onConfirm: () {
                Navigator.pop(context);
              },
            );
          },
        );
        return;
      }
      // Re-authenticate user before changing password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return RushFleetAlertDialog(
              title: 'lib/images/correct.png',
              message: "Password Updated Successfully!",
              confirmText: "Ok",
              onConfirm: () {
                Navigator.pop(context);
              },
            );
          },
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } on FirebaseAuthException {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return RushFleetAlertDialog(
              title: 'lib/images/delete.png',
              message: 'Old Password Is Incorrect',
              confirmText: "Ok",
              onConfirm: () {
                Navigator.pop(context);
              },
            );
          },
        );
      }
    }
  }

  Future<void> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection("riders")
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        setState(() {
          firstname = "${userDoc['first_name']}";
        });
      }
      if (userDoc.exists) {
        setState(() {
          secondname = "${userDoc['last_name']}";
        });
      }
      if (userDoc.exists) {
        setState(() {
          phoneNumber = "${userDoc['rider_number']}";
        });
      }
      if (userDoc.exists) {
        setState(() {
          email = "${userDoc['email']}";
        });
      }
    }
  }

  void signOut() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => IntroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF061F16),
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout_outlined, color: Colors.white, size: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "Personal Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 180,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "First Name",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      firstname.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Last Name",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      secondname.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  phoneNumber.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset("lib/images/flag.png", height: 23),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  email.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.mail, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 65,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 5,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Enter Current Password",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 3),
                                    LoginTextfield2(
                                      hintText: "",
                                      controller: _currentPasswordController,
                                      obscureText: _obscureCurrentPassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureCurrentPassword =
                                    !_obscureCurrentPassword;
                              });
                            },
                            icon: Icon(
                              _obscureCurrentPassword
                                  ? Icons.lock
                                  : Icons.lock_open_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "New Password",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 65,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 5,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Enter New Password",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 3),
                                    LoginTextfield2(
                                      hintText: "",
                                      controller: _newPasswordController,
                                      obscureText: _obscureNewPassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 65,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 5,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Comfirm New Password",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 3),
                                    LoginTextfield2(
                                      hintText: "",
                                      controller: _confirmPasswordController,
                                      obscureText: _obscureConfirmPassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    MyButtons(
                      text: "Save Changes",
                      color: Color(0xFF12AA6C),
                      fontcolor: Colors.white,
                      border: Border(),
                      onTap: changePassword,
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
