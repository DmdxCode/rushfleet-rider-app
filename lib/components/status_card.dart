import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatefulWidget {
  const StatusCard({super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  bool isOnline = true;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 100,
      decoration: BoxDecoration(color: Color(0xFF061F16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status: ${isOnline ? 'Online' : 'Offline'}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isOnline
                        ? "Open to any delivery."
                        : "Not accepting deliveries.",
                    style: TextStyle(color: Color(0XFFD4E9E2), fontSize: 15),
                  ),
                ],
              ),
              Switch(
                value: isOnline,
                onChanged: (value) {
                  setState(() {
                    isOnline = value;
                  });
                  if (user != null) {
                    FirebaseFirestore.instance
                        .collection('riders')
                        .doc(user!.uid)
                        .update({'online': value});
                  }
                },
                activeColor: Colors.white,
                activeTrackColor: Color(0xFF12AA6C),
                inactiveTrackColor: Color(0XFFD4E9E2),
                inactiveThumbColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
