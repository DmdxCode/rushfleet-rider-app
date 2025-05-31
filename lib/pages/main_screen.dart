import 'package:flutter/material.dart';
import 'package:rushfleet_rider/pages/home_page.dart';
import 'package:rushfleet_rider/pages/orders_page.dart';
import 'package:rushfleet_rider/pages/rider_profile_page.dart';
import 'package:rushfleet_rider/pages/rider_wallet_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    RiderWalletPage(),
    OrdersPage(),
    RiderProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF12AA6C),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12, color: Color(0XFFD4E9E2)),
        unselectedLabelStyle: TextStyle(fontSize: 10, color: Colors.grey),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("lib/images/home.png", height: 20),
            activeIcon: Image.asset(
              "lib/images/home.png",
              height: 24,
              color: Color(0xFF12AA6C),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("lib/images/wallet (1).png", height: 20),
            activeIcon: Image.asset(
              "lib/images/wallet (1).png",

              height: 24,
              color: Color(0xFF12AA6C),
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("lib/images/file.png", height: 20),
            activeIcon: Image.asset(
              "lib/images/file.png",
              height: 24,
              color: Color(0xFF12AA6C),
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("lib/images/user (1).png", height: 20),
            activeIcon: Image.asset(
              "lib/images/user (1).png",
              height: 24,
              color: Color(0xFF12AA6C),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
