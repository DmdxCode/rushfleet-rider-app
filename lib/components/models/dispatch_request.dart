import 'package:cloud_firestore/cloud_firestore.dart';

class DispatchRequest {
  final String id;
  final String pickupAddress;
  final String deliveryAddress;
  final String contactName;
  final String contactNumber;
  final String itemDescription;

  DispatchRequest({
    required this.id,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.contactName,
    required this.contactNumber,
    required this.itemDescription,
  });

  factory DispatchRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DispatchRequest(
      id: doc.id,
      pickupAddress: data['pickupAddress'] ?? '',
      deliveryAddress: data['deliveryAddress'] ?? '',
      contactName: data['contactName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      itemDescription: data['itemDescription'] ?? '',
    );
  }
}
