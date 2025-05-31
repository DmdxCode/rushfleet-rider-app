import 'package:flutter/material.dart';

class SignInAlertDialog extends StatelessWidget {
  // final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;

  const SignInAlertDialog({
    super.key,
    // required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF061F16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Center(child: Image.asset('lib/images/delete.png', height: 45)),
      content: SizedBox(
        height: 20,
        child: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            child: Text(
              cancelText!,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(width: 1.0, color: Colors.green),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // adjust radius as needed
                  ),
                ),
              ),

              onPressed: onConfirm,
              child: Text(
                confirmText,
                style: const TextStyle(color: Color(0xFF12AA6C)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
