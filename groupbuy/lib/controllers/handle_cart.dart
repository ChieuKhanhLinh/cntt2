import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groupbuy/models/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  final _items = {}.obs;
  final auth = FirebaseAuth.instance;

  void addItems(Item item, int quantity) {
    if (_items.containsKey(item)) {
      _items[item] += quantity;
    } else {
      _items[item] = quantity;
    }

    // Get.snackbar(
    //   'Thêm vào giỏ hàng',
    //   'Bạn đã thêm ${item.name} x $quantity vào giỏ hàng',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.white,
    //   duration: const Duration(seconds: 1),
    // );
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
      _items.entries.map((item) => item.key.minprice * item.value).toList();

  get total => _items.isNotEmpty
      ? _items.entries
          .map((item) => item.key.minprice * item.value)
          .toList()
          .reduce((value, element) => value + element)
      : 0;
}
