import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rushfleet_rider/pages/orders_page.dart';

class AvailableOrderCard extends StatefulWidget {
  const AvailableOrderCard({super.key});

  @override
  State<AvailableOrderCard> createState() => _AvailableOrderCardState();
}

class _AvailableOrderCardState extends State<AvailableOrderCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('dispatch_requests')
              .where('status', isEqualTo: 'Pending')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(); // or loading spinner if preferred
        }

        final pendingOrders = snapshot.data?.docs ?? [];

        return Container(
          height: 130,
          width: 420,
          decoration: BoxDecoration(
            color: const Color(0XFFD4E9E2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("lib/images/package.png", height: 70),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${pendingOrders.length} delivery order${pendingOrders.length == 1 ? '' : 's'} found!",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersPage()),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "view details",
                            style: TextStyle(color: Color(0xFF12AA6C)),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Color(0xFF12AA6C),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
