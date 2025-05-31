import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rushfleet_rider/components/dispatch_card.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<void> updateDispatchStatus(String dispatchId, String newStatus) async {
    {
      await FirebaseFirestore.instance
          .collection('dispatch_requests')
          .doc(dispatchId)
          .update({'status': newStatus});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF061F16),
        title: Text(
          "Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('dispatch_requests')
                .where(
                  'status',
                  whereIn: [
                    'Pending',
                    'Accepted',
                    'Picked Up',
                    'On The Way',
                    'Delivered',
                  ],
                )
                .orderBy('timestamp', descending: true)
                .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var dispatches = snapshot.data!.docs;

          return ListView.builder(
            itemCount: dispatches.length,
            itemBuilder: (context, index) {
              var dispatchData =
                  // ignore: unnecessary_cast
                  dispatches[index].data() as Map<String, dynamic>;
              var dispatchId = dispatches[index].id;

              // Map the Firestore fields to expected field names
              var mappedData = {
                "timestamp":
                    (dispatchData["timestamp"] as Timestamp?)?.toDate(),
                "amount": dispatchData["vehicle_price"]?.toString() ?? "0.00",
                "pickup_address": dispatchData["pick_up_address"] ?? "Unknown",
                "delivery_name": dispatchData["contact_name"] ?? "Unknown",
                "delivery_address":
                    dispatchData["delivery_address"] ?? "Unknown",
                "status": dispatchData["status"] ?? "Completed",
                "payment_method": dispatchData["payment_method"] ?? "Unknown",
                "order_id": dispatchData["order_id"] ?? "Unknown",
                "item_description": dispatchData["item_description"] ?? "...",
                "selected_vehicle": dispatchData["selected_vehicle"] ?? "...",
                "vehicle_price": dispatchData["vehicle_price"] ?? "...",
                "contact_number": dispatchData["contact_number"] ?? "...",
                "cash": dispatchData["cash"] ?? "...",
                "note": dispatchData["note"] ?? "...",
                "payment_status": dispatchData["payment_status"] ?? "",
                "email": dispatchData["email"] ?? "",
              };

              return DispatchCard(
                request: mappedData,
                dispatchId: dispatchId,
                onUpdateStatus: updateDispatchStatus,
              );
            },
          );
        },
      ),
    );
  }
}
