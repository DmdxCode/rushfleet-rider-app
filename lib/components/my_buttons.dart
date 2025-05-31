import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final String text;
  final Color color;
  final Color fontcolor;
  final Border border;
  final void Function()? onTap;

  const MyButtons({
    super.key,
    required this.text,
    required this.color,
    required this.fontcolor,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: color,
          border: border,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: fontcolor,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
