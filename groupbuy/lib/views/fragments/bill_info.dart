import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'item_detail.dart';

class BillInfoPage extends StatefulWidget {
  const BillInfoPage({Key? key}) : super(key: key);

  @override
  State<BillInfoPage> createState() => _BillInfoPageState();
}

class _BillInfoPageState extends State<BillInfoPage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF40C800),
        automaticallyImplyLeading: false,
        title: Text('Thông tin đơn hàng đã đặt'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // stream: readItemsinBill(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print(snapshot.data);
            // final bill = snapshot.data!;
            return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
