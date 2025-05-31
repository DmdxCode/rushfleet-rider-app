import 'package:flutter/material.dart';
import 'package:rushfleet_rider/components/scrollable_view.dart';
import 'package:rushfleet_rider/components/status_card.dart';
import 'package:rushfleet_rider/components/user_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            UserCard(),
            StatusCard(),
            SizedBox(height: 15),
            ScrollableView(),
          ],
        ),
      ),
    );
  }
}
