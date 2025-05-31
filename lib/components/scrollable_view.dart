import 'package:flutter/material.dart';
import 'package:rushfleet_rider/components/available_order_card.dart';
import 'package:rushfleet_rider/components/transaction_history.dart';

class ScrollableView extends StatelessWidget {
  const ScrollableView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 385, // Set desired scrollable height
      child: SingleChildScrollView(
        child: Column(
          children: const [
            AvailableOrderCard(),
            SizedBox(height: 20),
            TransactionHistory(),
          ],
        ),
      ),
    );
  }
}
