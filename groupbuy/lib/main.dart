import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:groupbuy/views/app.dart';

import 'controllers/handle_cart.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(CartController());
  runApp(const GroupbuyApp());
}
