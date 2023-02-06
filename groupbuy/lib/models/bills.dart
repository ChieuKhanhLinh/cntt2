import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  final String userId;
  final String itemId;
  final String status;
  final int quantity;
  final int totalPrice;
  final String createdAt;
  final String address;

  Bill({
    this.userId = '',
    this.itemId = '',
    this.status = '',
    this.quantity = 0,
    this.totalPrice = 0,
    this.createdAt = '',
    this.address = '',
  });

  @override
  String toString() {
    return 'Bill( userId: $userId, itemId: $itemId, status: $status, quantity: $quantity, totalPrice: $totalPrice, createdAt: $createdAt, address: $address,)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'itemId': itemId,
      'status': status,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'createdAt': createdAt,
      'address': address,
    };
  }

  static Bill fromJson(Map<String, dynamic> json) => Bill(
    userId: json['userId'],
    itemId: json['itemId'],
    status: json['status'],
    quantity: int.parse(json['quantity'].toString()),
    totalPrice: int.parse(json['totalPrice'].toString()),
    createdAt: json['createdAt'],
    address: json['address'],
  );
}
