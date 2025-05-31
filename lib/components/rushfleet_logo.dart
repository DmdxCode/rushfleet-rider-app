import 'package:flutter/material.dart';

class RushfleetLogo extends StatelessWidget {
  const RushfleetLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "RushFleet",
          style: TextStyle(
            color: Color(0xFF12AA6C),
            fontWeight: FontWeight.w800,
            fontSize: 22,
            fontFamily: 'MazzardH-SemiBoldItalic.ttf',
          ),
        ),
        Image.asset(
          "lib/images/result.png",
          height: 45,
          width: 50,
          color: Colors.white,
        ),
      ],
    );
  }
}
