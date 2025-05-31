import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String? username;
  int balance = 0;
  int? _riderWalletBalance;
  bool _isLoadingBalance = false;

  @override
  void initState() {
    super.initState();
    getUsername();
    loadWalletBalance();
    fetchRiderWalletBalance();
  }

  Future<void> loadWalletBalance() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('riders')
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        final rawBalance = userDoc['rider_wallet_balance'] ?? 0;
        final int parsedBalance =
            rawBalance is int
                ? rawBalance
                : (rawBalance is double
                    ? rawBalance.toInt()
                    : int.tryParse(rawBalance.toString()) ?? 0);

        if (mounted) {
          setState(() {
            balance = parsedBalance;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading wallet balance: $e");
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
          username = "${userDoc['first_name']} ${userDoc['last_name']}";
        });
      }
    }
  }

  String formatCurrency(int amount) {
    return '₦${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  Future<void> fetchRiderWalletBalance() async {
    setState(() {
      _isLoadingBalance = true;
    });

    try {
      final rider = FirebaseAuth.instance.currentUser;
      if (rider == null) return;

      final riderDoc =
          await FirebaseFirestore.instance
              .collection('riders')
              .doc(rider.uid)
              .get();

      if (riderDoc.exists) {
        final balance = riderDoc.data()?['rider_wallet_balance'];
        setState(() {
          _riderWalletBalance =
              (balance is int) ? balance : int.tryParse(balance.toString());
        });
      }
    } catch (e) {
      debugPrint("Error fetching wallet balance: $e");
    } finally {
      setState(() {
        _isLoadingBalance = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF12AA6C)),

      height: 350,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const SizedBox(height: 50),
              const Text(
                "Hi 👋",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                username ?? "",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text(
                    'YOUR EARNINGS',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  IconButton(
                    icon:
                        _isLoadingBalance
                            ? const SizedBox(
                              child: CircularProgressIndicator(
                                constraints: BoxConstraints(
                                  minHeight: 1,
                                  maxHeight: 1,
                                ),
                                strokeWidth: 2,
                                color: Color(0xFF12AA6C),
                              ),
                            )
                            : const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                    onPressed:
                        _isLoadingBalance ? null : fetchRiderWalletBalance,
                    tooltip: 'Refresh Wallet Balance',
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    _riderWalletBalance != null
                        ? "NGN ${NumberFormat("#,##0").format(_riderWalletBalance)}"
                        : "Wallet: Loading...",
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Right Section
          Image.asset("lib/images/pngwing.com (7).png", height: 190),
        ],
      ),
    );
  }
}
