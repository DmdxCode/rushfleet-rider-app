import 'package:flutter/material.dart';
import 'package:rushfleet_rider/components/my_buttons.dart';
import 'package:rushfleet_rider/components/rushfleet_logo.dart';
import 'package:rushfleet_rider/pages/login_page.dart';
import 'package:rushfleet_rider/pages/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061F16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    SizedBox(height: 20),
                    RushfleetLogo(),
                    const SizedBox(height: 80),
                  ],
                ),
                SizedBox(height: 150),
                Container(
                  margin: EdgeInsetsDirectional.all(35),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Glad you made it here.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Want to help deliver merchandise?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Start earning with RushFleet",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      MyButtons(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        text: "Register with RushFleet",
                        color: Color(0xFF12AA6C),
                        fontcolor: Colors.white,
                        border: Border(),
                      ),
                      SizedBox(height: 10),
                      MyButtons(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        text: "Login to RushFleet",
                        color: Color(0xFF1D362B),
                        fontcolor: Colors.white,
                        border: Border(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
