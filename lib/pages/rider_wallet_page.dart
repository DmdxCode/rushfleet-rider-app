import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:rushfleet_rider/components/payment_textfield.dart';
import 'package:rushfleet_rider/main.dart';

class RiderWalletPage extends StatefulWidget {
  const RiderWalletPage({super.key});

  @override
  State<RiderWalletPage> createState() => _RiderWalletPageState();
}

class _RiderWalletPageState extends State<RiderWalletPage> {
  String? username;
  String? email;
  int balance = 0;

  final TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUsername();
    loadWalletBalance();
  }

  void _showAmountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: Text("Enter Amount"),
          content: PaymentTextfield(
            hintText: "E.g 1000",
            controller: amountController,
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                handlePaystackPayment(); // Call payment after dialog is closed
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> handlePaystackPayment() async {
    final amountText = amountController.text.trim();
    if (amountText.isEmpty || int.tryParse(amountText) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter a valid amount")));
      return;
    }

    int amountInKobo = int.parse(amountText) * 100;
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    Charge charge =
        Charge()
          ..amount = amountInKobo
          ..email = user.email ?? 'test@example.com'
          ..currency = 'NGN'
          ..reference = 'RUSHFLEET_${DateTime.now().millisecondsSinceEpoch}';

    try {
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
      );

      if (response.status == true) {
        await FirebaseFirestore.instance.collection('payments').add({
          'userId': user.uid,
          'email': charge.email,
          'amount': charge.amount,
          'reference': charge.reference,
          'status': 'success',
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update wallet balance inside the user's document
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('riders')
            .doc(user.uid);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userDoc);
          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

          int currentBalance =
              (snapshot['rider_wallet_balance'] as num?)?.toInt() ?? 0;

          int newBalance = currentBalance + (charge.amount ~/ 100);

          transaction.update(userDoc, {'rider_wallet_balance': newBalance});
        });

        loadWalletBalance(); // Refresh UI balance
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Failed or Cancelled'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed to launch.'),
          backgroundColor: Colors.red,
        ),
      );
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
          username = userDoc["first_name"];
          email = userDoc["email"];
        });
      }
    }
  }

  Future<void> loadWalletBalance() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance
            .collection('riders')
            .doc(user.uid)
            .get();

    if (userDoc.exists) {
      setState(() {
        balance = (userDoc['rider_wallet_balance'] as num?)?.toInt() ?? 0;
      });
    }
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF061F16),
        elevation: 0,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black, // Change status bar color to black
          statusBarIconBrightness: Brightness.light, // White icons
        ),
        title: Text(
          "Wallet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical:
                  MediaQuery.of(context).size.width > 600
                      ? (MediaQuery.of(context).size.width - 600) /
                          10 // Centered margin
                      : 5,
              horizontal:
                  MediaQuery.of(context).size.width > 600
                      ? (MediaQuery.of(context).size.width - 400) /
                          2 // Centered margin
                      : 20,
            ), // Default small margin on smaller screens
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to your Wallet, $username",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "Add money to your wallet to enjoy more intuitive experience",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 50),
                Container(
                  width: 400,
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Balance",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "NGN ${NumberFormat("#,##0").format(balance)}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.start,
                        ),

                        // Text.rich(TextSpan(children: [TextSpan()])),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: _showAmountDialog,
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(
                                25,
                              ),
                              color: Color(0xFF12AA6C),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF061F16),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Add money",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
