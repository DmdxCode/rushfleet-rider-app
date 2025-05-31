import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const PaymentTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
  });

  @override
  State<PaymentTextfield> createState() => _PaymentTextfieldState();
}

class _PaymentTextfieldState extends State<PaymentTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: 300,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              cursorColor: Colors.black,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.words,
              spellCheckConfiguration: SpellCheckConfiguration.disabled(),
              controller: widget.controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color(0xFF12AA6C),
                  width: 0.5,
                )),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF12AA6C)),
                ),
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                hintText: widget.hintText,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
