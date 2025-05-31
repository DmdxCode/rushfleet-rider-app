import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final int amount;
  final String type;
  final DateTime timestamp;

  const TransactionCard({
    super.key,
    required this.amount,
    required this.type,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0XFFD4E9E2))),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "lib/images/downloadrf.png",
              height: 50,
              color: Color(0xFF12AA6C),
            ),
            Column(
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF12AA6C),
                  ),
                ),
                Text(
                  DateFormat('dd MMM, h:mm a').format(timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Text(
              "+₦${NumberFormat('#,##0').format(amount)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF12AA6C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
