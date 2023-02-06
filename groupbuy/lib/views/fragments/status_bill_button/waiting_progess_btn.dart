import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controllers/handle_auth.dart';

class WaitingProgressBillPage extends StatefulWidget {
  const WaitingProgressBillPage({Key? key}) : super(key: key);
  static const String routeName = '/billInfo';
  @override
  State<WaitingProgressBillPage> createState() =>
      _WaitingProgressBillPageState();
}

class _WaitingProgressBillPageState extends State<WaitingProgressBillPage> {
  final auth = FirebaseAuth.instance;
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF40C800),
          title: Text('Đơn hàng đang xử lý'),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: readCustomerBuild(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              }
              if (snapshot.hasData) {
                final bills = snapshot.data!;
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: bills.map(_buildItem).toList(),
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _buildItem(Map<String, dynamic> bill) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(bill['itemImg']),
                      fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bill['itemName']}'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'x ${bill['quantity']}',
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.black54),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      NumberFormat.currency(locale: 'vi')
                          .format(bill['itemMinprice']),
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.electric_rickshaw_outlined,
                    color: Colors.green,
                  ),
                  Text(
                    '${bill['status']}',
                    style: TextStyle(color: Color.fromARGB(255, 116, 114, 114)),
                  )
                ],
              ),
              Spacer(),
              Text(
                NumberFormat.currency(locale: 'vi').format(bill['totalPrice']),
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> readCustomerBuild() {
    final bills = FirebaseFirestore.instance
        .collection('bills')
        .where('userId', isEqualTo: auth.currentUser!.uid)
        .where('status', isEqualTo: 'Đang xử lý')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    return bills;
  }
}
