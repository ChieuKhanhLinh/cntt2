import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String billId;
  final String userId;
  final String itemId;
  final String itemName;
  final int itemMinprice;
  final String itemImg;
  final String status;
  final int quantity;
  final int totalPrice;
  final String createdAt;
  final String address;

  Bill({
    this.billId = '',
    this.userId = '',
    this.itemId = '',
    this.itemName = '',
    this.itemMinprice = 0,
    this.itemImg = '',
    this.status = '',
    this.quantity = 0,
    this.totalPrice = 0,
    this.createdAt = '',
    this.address = '',
  });

  @override
  String toString() {
    return 'Bill( billId: $billId, userId: $userId, itemId: $itemId, itemName: $itemName, itemMinprice: $itemMinprice, itemImg: $itemImg, status: $status, quantity: $quantity, totalPrice: $totalPrice, createdAt: $createdAt, address: $address,)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'billId': billId,
      'userId': userId,
      'itemId': itemId,
      'itemName': itemName,
      'itemMinprice': itemMinprice,
      'itemImg': itemImg,
      'status': status,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'createdAt': createdAt,
      'address': address,
    };
  }

  static Bill fromJson(Map<String, dynamic> json) => Bill(
    billId: json['billId'],
    userId: json['userId'],
    itemId: json['itemId'],
    itemName: json['itemName'],
    itemMinprice: int.parse(json['itemMinprice'].toString()),
    itemImg: json['itemImg'],
    status: json['status'],
    quantity: int.parse(json['quantity'].toString()),
    totalPrice: int.parse(json['totalPrice'].toString()),
    createdAt: json['createdAt'],
    address: json['address'],
  );
}
