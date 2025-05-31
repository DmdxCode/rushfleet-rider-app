import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DispatchCard extends StatefulWidget {
  final Map<String, dynamic> request;
  final String dispatchId;
  final Future<void> Function(String, String)? onUpdateStatus;

  const DispatchCard({
    super.key,
    required this.request,
    required this.dispatchId,
    this.onUpdateStatus,
  });

  @override
  State<DispatchCard> createState() => _DispatchCardState();
}

class _DispatchCardState extends State<DispatchCard> {
  final GlobalKey<SlideActionState> _slideKey = GlobalKey();
  bool _isDropDownVisible = false;

  String getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'Pending':
        return 'Accepted';
      case 'Accepted':
        return 'Picked Up';
      case 'Picked Up':
        return 'On The Way';
      case 'On The Way':
        return 'Delivered';
      default:
        return '';
    }
  }

  String slideText(String currentStatus) {
    switch (currentStatus) {
      case 'Pending':
        return 'Slide to Accept';
      case 'Accepted':
        return 'Picked Up';
      case 'Picked Up':
        return 'On The Way';
      case 'On The Way':
        return 'Delivered';
      default:
        return '';
    }
  }

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: "NGN ",
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.request;

    final orderId = data['order_id'] ?? 'N/A';
    final pickupAddress = data['pickup_address'] ?? 'N/A';
    final deliveryAddress = data['delivery_address'] ?? 'N/A';
    final deliveryName = data['delivery_name'] ?? 'N/A';
    final status = data['status'] ?? 'Pending';
    final item = data['item_description'] ?? 'N/A';
    final contactNumber = data['contact_number'] ?? 'N/A';
    final note = data['note'] ?? '...';
    final vehiclePrice = data['vehicle_price'] ?? 'N/A';
    final selectedVehicle = data['selected_vehicle'] ?? 'N/A';
    final cash = data['cash'] ?? 'N/A';
    // final totalPrice = (data['total_price'] ?? 0) as int;

    final formattedDate =
        data["timestamp"] != null
            ? DateFormat("dd MMMM yyyy, hh:mm a").format(data["timestamp"])
            : "Unknown Date";

    void toggleDropdown() {
      setState(() {
        _isDropDownVisible = !_isDropDownVisible;
      });
    }

    Future<void> updateStatusAndWallet(String newStatus) async {
      final rider = FirebaseAuth.instance.currentUser;
      if (rider == null) return;

      final riderId = rider.uid;
      final dispatchRef = FirebaseFirestore.instance
          .collection("dispatch_requests")
          .doc(widget.dispatchId);
      final riderRef = FirebaseFirestore.instance
          .collection("riders")
          .doc(riderId);

      final transactionRef =
          FirebaseFirestore.instance.collection("transactions").doc();

      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final dispatchSnap = await transaction.get(dispatchRef);
          final riderSnap = await transaction.get(riderRef);

          if (!dispatchSnap.exists || !riderSnap.exists) {
            debugPrint("Dispatch or Rider document not found");
            return;
          }

          final currentStatus = dispatchSnap["status"];
          if (currentStatus == "Delivered") {
            debugPrint("Dispatch already delivered. Skipping update.");
            return;
          }

          final currentBalanceRaw = riderSnap["rider_wallet_balance"];
          final int currentBalance =
              currentBalanceRaw is int
                  ? currentBalanceRaw
                  : int.tryParse(currentBalanceRaw.toString()) ?? 0;

          final feeRaw = dispatchSnap["total_price"];
          final double feeDouble =
              feeRaw is double
                  ? feeRaw
                  : double.tryParse(feeRaw.toString()) ?? 0.0;
          final int fee = feeDouble.round(); // Convert to int
          final riderNumber = riderSnap.data()?['rider_number'] ?? 'Unknown';
          final dataToUpdate = {
            "status": newStatus,
            "updated_at": FieldValue.serverTimestamp(),
            'rider_id': riderId,
            'rider_number': riderNumber,
          };

          if (newStatus == "Accepted") {
            dataToUpdate["rider_id"] = riderId;
          }

          transaction.update(dispatchRef, dataToUpdate);

          if (newStatus == "Delivered") {
            final updatedBalance = currentBalance + fee;

            // Update wallet
            transaction.update(riderRef, {
              "rider_wallet_balance": updatedBalance,
            });

            // Add transaction record
            transaction.set(transactionRef, {
              "amount": fee,
              "rider_id": riderId,
              "type": "Credit",
              "timestamp": FieldValue.serverTimestamp(),
            });

            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Order $orderId has been $newStatus',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  contentPadding: EdgeInsets.all(1),
                );
              },
            );
            // debugPrint(
            //   "Added NGN $fee to wallet. New balance: $updatedBalance",
            // );
          }
        });

        setState(() {
          widget.request['status'] = newStatus;
        });
      } catch (e) {
        debugPrint("Failed to update status or wallet: $e");
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating dispatch: $e")));
      }
    }

    Future<bool> showStatusConfirmationDialog(String newStatus) async {
      return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0XFFD4E9E2),
                title: Text('Confirm Status Change'),
                content: Text(
                  'Are you sure you want to change the status to "$newStatus" ?',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color?>(
                        Color(0xFF12AA6C),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          ) ??
          false; // Default to false if dialog is dismissed
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0XFFD4E9E2),

        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                status,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Requested on: $formattedDate",
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 15),

          // Address Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(
                    "lib/images/up-arrow.png",
                    height: 20,
                    color: const Color(0xffFF9E00),
                  ),
                  const SizedBox(height: 5),
                  Image.asset("lib/images/Group 6.jpg", height: 35),
                  const SizedBox(height: 5),
                  Image.asset(
                    "lib/images/downloadrf.png",
                    height: 20,
                    color: const Color(0xFF12AA6C),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Picked From",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      pickupAddress,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Delivered To",
                      style: TextStyle(
                        color: Color(0xFF12AA6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      deliveryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      deliveryAddress,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(),

          // Toggle Details
          GestureDetector(
            onTap: toggleDropdown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "View more details",
                  style: TextStyle(
                    color: Color(0xFF12AA6C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.asset(
                  _isDropDownVisible
                      ? "lib/images/drop2.png"
                      : "lib/images/drop.png",
                  height: 15,
                  color: const Color(0xFF12AA6C),
                ),
              ],
            ),
          ),

          if (_isDropDownVisible)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  _buildDetailRow("Item", item),
                  _buildDetailRow("Contact Number", contactNumber),
                  _buildDetailRow("Vehicle", selectedVehicle),
                  _buildDetailRow("Price", vehiclePrice),
                  _buildDetailRow("Note", note),
                  _buildDetailRow("Receive Cash", cash),
                ],
              ),
            ),

          const SizedBox(height: 10),

          // Slide Button
          if (status != 'Delivered')
            SizedBox(
              width: double.infinity,
              child: SlideAction(
                key: _slideKey,
                height: 50,
                innerColor: Colors.white,
                outerColor: const Color(0xFF12AA6C),
                elevation: 2,
                sliderRotate: false,
                reversed: false,

                sliderButtonIcon: Image.asset(
                  "lib/images/result.png",
                  height: 35,
                  width: 35,
                  color: const Color(0xFF12AA6C),
                ),
                sliderButtonIconPadding: 5,
                text: slideText(status),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                onSubmit: () async {
                  final newStatus = getNextStatus(status);
                  final confirm = await showStatusConfirmationDialog(newStatus);
                  if (confirm) {
                    await updateStatusAndWallet(newStatus);
                  }
                  _slideKey.currentState?.reset(); // Reset either way
                },
              ),
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
