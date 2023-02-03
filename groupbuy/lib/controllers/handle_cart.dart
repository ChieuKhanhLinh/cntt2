import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groupbuy/models/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class CartController  {
//   final auth = FirebaseAuth.instance;
//
//   //Set Cart Info from database
//   Future cartInfo({
//     Item? item,
//     Int? quantity,
//   }) async {
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     FirebaseFirestore.instance
//         .collection('carts')
//         .doc(auth.currentUser!.uid)
//         .set({
//       'name': username,
//       'phone': phone,
//       'email': email,
//       'role': 'user',
//     });
//   }

class CartController extends GetxController {

  final _items = {}.obs;
  final auth = FirebaseAuth.instance;
  late bool checkList = false;


  void addItems(Item item, int quantity) {
    // print(item.id);
    //
    // final currentList = _items.keys.toList();
    // print(currentList);
    // print(currentList.length);
    // if (currentList.length!=0) {
    //   for (final a in currentList) {
    //     if (a.id == item.id ) {
    //       checkList = true;
    //       break;
    //     }
    //   }
    // }
    // print(checkList);

    if (_items.containsKey(item) ) {
      _items[item] += quantity;
    } else {
      _items[item] = quantity;
    }
    print(_items);

    Get.snackbar(
      'Thêm vào giỏ hàng',
      'Bạn đã thêm ${item.name} x $quantity vào giỏ hàng',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 1),
    );
    checkList = false;

    //Set user Info from database
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // final cartInfo = FirebaseFirestore.instance.collection('carts').doc();

  }

  void removeItem(Item item) {
    if (_items.containsKey(item) && _items[item] == 1) {
      _items.removeWhere((key, value) => key == item);
    } else {
      _items[item] -= 1;
    }
  }

  void removeOneItem(Item item) {
    if (_items.containsKey(item)) {
      _items.removeWhere((key, value) => key == item);
    }
  }

  void addItem(Item item) {
    _items[item] += 1;
  }

  get items => _items;

  get itemSubtotal =>
      _items.entries.map((item) => item.key.minprice* item.value).toList();

  get total => _items.isNotEmpty
      ? _items.entries
      .map((item) => item.key.minprice * item.value)
      .toList()
      .reduce((value, element) => value + element)
      : 0;
}