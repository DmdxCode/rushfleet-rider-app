import 'package:flutter/material.dart';

class PasswordTextfield extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  const PasswordTextfield({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.keyboardType,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Color(0xFF12AA6C),
        width: 0.5,
      ))),
      child: Row(
        children: [
          SizedBox(
            width: 312,
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              controller: widget.controller,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Color(0XFFD4E9E2),
                ),
                border: InputBorder.none,
                icon: Icon(
                  color: Colors.white,
                  widget.icon,
                ),
                hintText: widget.hintText,
              ),
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
            ),
          ),
          IconButton(
            onPressed: () => {
              setState(() {
                _obscureText = !_obscureText;
              })
            },
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
