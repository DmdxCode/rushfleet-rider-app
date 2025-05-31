import 'package:flutter/material.dart';
import 'package:rushfleet_rider/pages/home_page.dart';
import 'package:rushfleet_rider/pages/orders_page.dart';
import 'package:rushfleet_rider/pages/rider_profile_page.dart';
import 'package:rushfleet_rider/pages/rider_wallet_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BottomAppBar(
        height: 70,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      "lib/images/home.png",
                      height: 23,
                      color: Color(0xFF061F16),
                    ),
                    Text("Home", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RiderWalletPage()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      "lib/images/wallet (1).png",
                      height: 23,
                      color: Color(0xFF061F16),
                    ),
                    Text("Wallet", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      "lib/images/file.png",
                      height: 23,
                      color: Color(0xFF061F16),
                    ),
                    Text("Orders", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RiderProfilePage()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      "lib/images/user (1).png",
                      height: 23,
                      color: Color(0xFF061F16),
                    ),
                    Text("Profile", style: TextStyle(fontSize: 10)),
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
