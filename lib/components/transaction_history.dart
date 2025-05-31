import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rushfleet_rider/components/transanction_card.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('transactions')
                        .where('rider_id', isEqualTo: currentUser?.uid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = snapshot.data?.docs ?? [];

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        "No transactions yet.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final data =
                          transactions[index].data() as Map<String, dynamic>;

                      final totalPriceStr = data['amount'] ?? "0";
                      final totalPrice =
                          double.tryParse(totalPriceStr.toString()) ?? 0;
                      final type = data['type'] ?? "";
                      final timestamp =
                          (data['timestamp'] as Timestamp).toDate();

                      return TransactionCard(
                        amount: totalPrice.toInt(),
                        type: type,
                        timestamp: timestamp,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
