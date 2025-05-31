import 'package:flutter/material.dart';

class LoginTextfield2 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  const LoginTextfield2({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: SizedBox(
        width: 300,
        child: TextField(
          autocorrect: false,
          enableSuggestions: false,
          spellCheckConfiguration: SpellCheckConfiguration.disabled(),
          cursorColor: Colors.black,
          cursorHeight: 15,
          controller: controller,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            hintText: hintText,
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
