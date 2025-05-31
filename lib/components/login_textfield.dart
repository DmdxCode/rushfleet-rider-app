import 'package:flutter/material.dart';

class LoginTextfield extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const LoginTextfield({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.keyboardType,
  });

  @override
  State<LoginTextfield> createState() => _LoginTextfieldState();
}

class _LoginTextfieldState extends State<LoginTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF12AA6C), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.sentences,
              spellCheckConfiguration: SpellCheckConfiguration.disabled(),
              controller: widget.controller,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Color(0XFFD4E9E2)),
                border: InputBorder.none,
                icon: Icon(color: Colors.white, widget.icon),
                hintText: widget.hintText,
              ),
              keyboardType: widget.keyboardType,
            ),
          ),
        ],
      ),
    );
  }
}
