import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupbuy/models/bills.dart';
import 'package:intl/intl.dart';

class SetBillStatusPage extends StatefulWidget {
  const SetBillStatusPage({Key? key, required this.bill}) : super(key: key);
  final Map<String, dynamic> bill;
  @override
  State<SetBillStatusPage> createState() => _SetBillStatusPageState();
}

class _SetBillStatusPageState extends State<SetBillStatusPage> {
  final controllerBillStatus = TextEditingController();
  List<String> _billstatus = ["Đóng gói", "Vận chuyển", "Nhận hàng"];

  @override
  void initState() {
    controllerBillStatus.text = widget.bill['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật tình trạng đơn'),
        elevation: 0,
        backgroundColor: const Color(0xFF40C800),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        billInform(),
        SizedBox(
          height: 9,
        ),
        customerInform(),
        SizedBox(
          height: 9,
        ),
        itemInform(),
        SizedBox(
          height: 9,
        ),
        Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Row(
            children: [
              Text(
                'Tổng tiền',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                NumberFormat.currency(locale: 'vi')
                    .format(widget.bill['totalPrice']),
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: controllerBillStatus,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (String value) {
                  controllerBillStatus.text = value;
                },
                itemBuilder: (BuildContext context) {
                  return _billstatus.map<PopupMenuItem<String>>((String value) {
                    return new PopupMenuItem(
                        child: new Text(value), value: value);
                  }).toList();
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        if (widget.bill['status'] != 'Nhận hàng')
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 48,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              child: const Text(
                'Cập nhật trạng thái đơn hàng',
                style: TextStyle(fontSize: 16.0),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF025B05))),
              onPressed: () async {
                final bill = Bill(
                    billId: widget.bill['billId'],
                    userId: widget.bill['userId'],
                    itemId: widget.bill['itemId'],
                    quantity: widget.bill['quantity'],
                    totalPrice: widget.bill['totalPrice'],
                    createdAt: widget.bill['createdAt'],
                    address: widget.bill['address'],
                    status: controllerBillStatus.text);
                updateStatus(bill);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đơn đã cập nhật thành công!')));
                Navigator.of(context).pop();
                return;
              },
            ),
          ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 48,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            child: const Text(
              'Hủy đơn mua',
              style: TextStyle(fontSize: 16.0),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () async {
              final confirmed = await confirm(
                context,
                title: const Text('Confirm'),
                content: Text('Bạn có chắc muốn hủy đơn mua chung này?'),
                textOK: const Text('Có'),
                textCancel: const Text('Quay lại'),
              );
              if (confirmed) {
                deleteBill(widget.bill['billId']);
                Fluttertoast.showToast(
                    msg: "Hủy đơn mua thành công",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 14.0);
                Navigator.pop(context);
              }
              print('pressedCancel');
            },
          ),
        ),
      ]),
    );
  }

  Widget billInform() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.receipt_outlined,
            color: Colors.indigo,
            size: 20,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn hàng: ${widget.bill['billId']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Ngày đặt: ${widget.bill['createdAt']}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Tình trạng: ${widget.bill['status']}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> customerInform() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.bill['userId'])
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person_pin_circle_outlined,
                  color: Colors.indigo,
                  size: 20,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin người đặt',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Tên: ${snapshot.data['name']}',
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Số điện thoại:  ${snapshot.data['phone']}',
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black54),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Địa chỉ:  ${widget.bill['address']}',
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> itemInform() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('items')
          .doc(widget.bill['itemId'])
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: 40,
                child: Text(
                  'x ${widget.bill['quantity'].toString()}',
                  style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  snapshot.data['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                NumberFormat.currency(locale: 'vi')
                    .format(snapshot.data['minprice']),
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
              ),
            ]),
          );
        }
        return Container();
      },
    );
  }
}

Future updateStatus(Bill bill) async {
  final docBill =
      FirebaseFirestore.instance.collection('bills').doc(bill.billId);

  final json = bill.toJson();
  await docBill.update(json);
}

Future deleteBill(String id) async {
  final docBill = FirebaseFirestore.instance.collection('bills').doc(id);
  await docBill.delete();
}
