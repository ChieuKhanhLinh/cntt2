import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/views/fragments/change_address.dart';
import 'package:intl/intl.dart';

import '../../controllers/handle_auth.dart';
import '../../controllers/handle_cart.dart';
import '../../controllers/handle_user.dart';
import '../../models/bills.dart';
import '../../models/items.dart';
import '../../models/user.dart';

class CheckOut extends StatefulWidget {

  static String routeName = '/check-out';

  const CheckOut({Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  final auth = FirebaseAuth.instance.currentUser!.uid;
  final CartController controller = Get.find();
  late final Item item;
  late final int index;

  String addressChange = '';

  @override

  void initState() {
    // TODO: implement initState
    super.initState();

    fetch().then((user) {
      setState(() {
        addressChange = user["address"];
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF40C800),
        title: const Text('Thanh toán'),
      ),
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder<Users?>(
                future: HandleUser().readUserInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print('${snapshot.error}');
                    return GestureDetector(
                      onTap: () async {
                        final finalAddress = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeAddress (
                              address: addressChange,
                            ),
                          ),
                        );
                        setState(() {
                          addressChange = finalAddress;
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        height: 80,
                        child: ListTile(
                          title: Text(
                            'Địa chỉ nhận hàng',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          subtitle: Text(
                            addressChange,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Color(0xFF654C24),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ),
                          leading: Icon(Icons.add_location_alt_outlined, color: Color(0xFF273B4A), size: 30,),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Color(0xFF273B4A), size: 20,),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData){
                    final user = snapshot.data;
                    return GestureDetector(
                      onTap: () async {
                        final finalAddress = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeAddress (
                              address: user.address,
                            ),
                          ),
                        );
                        setState(() {
                          addressChange = finalAddress;
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        height: 80,
                        child: ListTile(
                          title: Text(
                            'Địa chỉ nhận hàng',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          subtitle: Text(
                            addressChange,
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Color(0xFF654C24),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                          ),
                          leading: Icon(Icons.add_location_alt_outlined, color: Color(0xFF273B4A), size: 30,),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, color: Color(0xFF273B4A), size: 20,),
                        ),
                      ),
                    );
                  }
                  else {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
              ),
              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: Colors.grey.shade300))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Đơn hàng của bạn',
                        style:
                        TextStyle(fontSize: 15, color: Colors.blueGrey),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.items.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'x ${controller.items.values.toList()[index].toString()}',
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  controller.items.keys.toList()[index].name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  softWrap: false,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                NumberFormat.currency(locale: 'vi').format(
                                    controller.itemSubtotal.toList()[index]),
                                style: TextStyle(
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                              ElevatedButton(
                                child: Icon(
                                  Icons.clear,
                                  size: 10,
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.removeOneItem(controller
                                        .items.keys
                                        .toList()[index]);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Colors.black54.withOpacity(0.3),
                                    shape: CircleBorder(),
                                    minimumSize: Size(20, 20),
                                    elevation: 0.0),
                              )
                            ],
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: 90,
              padding: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng cộng',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          NumberFormat.currency(locale: 'vi')
                              .format(controller.total),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: controller.items.length == 0 || addressChange.compareTo('') ==0
                          ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Chưa nhập địa chỉ hoặc bạn đã xóa hết đơn hàng trong giỏ. Vui lòng thử lại')));
                      }
                          : () {
                        fetch();
                        updateItemOrdered();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Tham gia nhóm thành công!')));
                        controller.items.clear();
                        Navigator.popAndPushNamed(
                            context, '/');
                      },
                      child: const Text(
                        'Đặt hàng',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xFF025B05))),
                    ),
                  ]),
            ),
          ),
        ],
      )
    );
  }

  Future<dynamic> fetch() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(auth).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data();
    }
    return null;
  }

  Future updateItem(Item item) async {
    final docItem = FirebaseFirestore.instance.collection('items').doc(item.id);
    final json = item.toJson();
    await docItem.update(json);
  }

  Future createBill(Bill bill) async {
    final docBill = FirebaseFirestore.instance.collection('bills').doc();
    final json = bill.toJson();
    await docBill.set(json);
  }

  Future updateItemOrdered() async {
    final keyItemList = controller.items.keys.toList();
    String itemStatus ;
    for (final a in keyItemList) {
      a.ordered + 1 == a.totalorder
          ? itemStatus = 'Thành công'
          : itemStatus = 'Đang diễn ra';
      final item = Item(
        id: a.id,
        name: a.name,
        detail: a.detail,
        initialprice: a.initialprice,
        minprice: a.minprice,
        totalorder: a.totalorder,
        ordered : a.ordered + 1,
        endtime: a.endtime,
        imgLink: a.imgLink ,
        status: itemStatus,
      );
      updateItem(item);
    }

    final DateTime now = DateTime.now();
    final String time = DateFormat('HH:mm dd/MM/yyyy').format(now).toString();
    for (final a in keyItemList) {
      final bill = Bill(
        userId: FirebaseAuth.instance.currentUser!.uid,
        itemId: a.id,
        status: 'Đang xử lý',
        quantity: controller.items[a],
        totalPrice: controller.total,
        createdAt: time,
        address: addressChange,
      );
      createBill(bill);
    }
  }
}
