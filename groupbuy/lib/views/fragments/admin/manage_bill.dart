import 'package:flutter/material.dart';
import 'package:groupbuy/models/items.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuy/models/menu_item.dart';
import 'package:groupbuy/views/fragments/admin/set_bill_status.dart';
import 'package:groupbuy/views/fragments/admin/update_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageBillPage extends StatefulWidget {
  const ManageBillPage({Key? key}) : super(key: key);
  static const String routeName = '/manageBill';

  @override
  State<ManageBillPage> createState() => _ManageBillPageState();
}

class _ManageBillPageState extends State<ManageBillPage> {
  final auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn mua'),
        elevation: 0,
        backgroundColor: const Color(0xFF40C800),
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: [
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: readBill(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final bills = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: bills.map(_builderItem).toList(),
                  );
                } else {
                  return const Center(
                    child: const CircularProgressIndicator(),
                  );
                }
              },
            ),
          ]),
    );
  }

  Widget _builderItem(Map<String, dynamic> bill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetBillStatusPage(bill: bill)),
                    );
                  },
                  backgroundColor: Color.fromARGB(255, 25, 211, 115),
                  foregroundColor: Colors.white,
                  icon: Icons.system_update_alt_rounded,
                  label: 'Update',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(width: 1.0, color: Colors.grey.shade300))),
              height: 140.0,
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Đơn từ: ${bill['address']}',
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                          Text(
                            'Tình trạng: ${bill['status']}',
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 141, 140, 140)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                          const Spacer(),
                          Text(
                            'Giá: ${NumberFormat.currency(locale: 'vi').format(bill['totalPrice'])}',
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.green),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_alarm_outlined,
                                color: Colors.indigo,
                              ),
                              Text(
                                'Ngày: ${bill['createdAt']}',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          if (bill['status'] == 'Nhận hàng')
            Positioned(
                right: 0,
                child: Container(
                  width: 80,
                  color: Colors.green,
                  child: Text(
                    'Giao hàng thành công',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )),
        ],
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> readBill() {
    final bills = FirebaseFirestore.instance
        .collection('bills')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    return bills;
  }
}
