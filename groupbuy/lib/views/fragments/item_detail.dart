import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupbuy/models/items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:groupbuy/controllers/handle_cart.dart';
import 'package:get/get.dart';

import '../../controllers/handle_auth.dart';
import '../../models/bills.dart';
import 'auth/sign_in_page.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.item}) : super(key: key);
  static const String routeName = '/item_detail';
  final Item item;

  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int itemCount = 1;
  bool isBtnDisabled = true;

  final cartController = Get.put(CartController());

  final auth = FirebaseAuth.instance;


  Stream<List<Map<String, dynamic>>> readBillInfo(){
    final docBill = FirebaseFirestore.instance
        .collection('bills')
        .where('userId', isEqualTo: auth.currentUser?.uid )
        .where('itemId', isEqualTo: widget.item.id)
        .snapshots()
        .asyncMap((snapshot) => snapshot.docs.map((e) => e.data()).toList());
    return docBill;
  }


  @override
  
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.item.imgLink != ''
                                  ? widget.item.imgLink
                                  : 'https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      if (widget.item.ordered == widget.item.totalorder)
                        Positioned(
                          top: 100,
                          left: 110,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.shade900,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Hết lượt mua',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                letterSpacing: 0.5,
                                color: const Color(0xFFE7E7E7),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  Column(children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      height: 70,
                      color: Colors.green.shade900,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: Text(
                                    NumberFormat.currency(locale: 'vi')
                                        .format(widget.item.initialprice),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade300,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    NumberFormat.currency(locale: 'vi')
                                        .format(widget.item.minprice),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.item.ordered.toString() +
                                        ' người tham gia nhóm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Kết thúc sau:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      _timeBox(item: widget.item),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ]),
                    ),
                    Container(
                      height: 140,
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 3,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                  child: Icon(
                                Icons.add_shopping_cart_outlined,
                                color: Colors.lightGreen,
                                size: 15,
                              )),
                              TextSpan(
                                  text: 'Cần thêm ' +
                                      (widget.item.totalorder -
                                              widget.item.ordered)
                                          .toString() +
                                      ' người tham gia nữa để đạt giá thấp nhất',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black))
                            ])),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 100),
                      child: Text(
                        widget.item.detail,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                    )
                  ])
                ],
              ),
              if (widget.item.ordered < widget.item.totalorder)
              Positioned(
                  bottom: 0,
                  child: StreamBuilder (
                    stream: readBillInfo(),
                    builder: (context, AsyncSnapshot snapshot) {

                      if (auth.currentUser == null) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          height: 90,
                          padding: EdgeInsets.all(20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (itemCount > 1) {
                                      setState(() {
                                        itemCount--;
                                      });
                                    }
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.minus,
                                    size: 10,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.green.shade900,
                                      primary: Colors.lightGreen.shade50,
                                      onSurface: Colors.grey.shade600,
                                      minimumSize: Size(30, 30),
                                      elevation: 0.0),
                                ),
                                Text(
                                  itemCount.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      itemCount++;
                                    });
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: 10,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.green.shade900,
                                      primary: Colors.lightGreen.shade50,
                                      minimumSize: Size(30, 30),
                                      onSurface: Colors.grey.shade600,
                                      elevation: 0.0),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (auth.currentUser != null) {
                                      cartController.addItems(widget.item, itemCount);
                                      // print(widget.item);
                                    } else {
                                      // Navigator.pushNamed(context, SignInPage.routeName);
                                      Get.off(SignInPage());
                                    }
                                  },
                                  child: Text(
                                    'Thêm vào giỏ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Colors.green.shade900,
                                    minimumSize: Size(180, 50),
                                    onSurface: Colors.grey.shade600,
                                  ),
                                ),
                              ]),
                        );
                      }

                      if (snapshot.hasError) {
                        print('Xảy ra lỗi ${snapshot.error}');
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          height: 90,
                          padding: EdgeInsets.all(20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (itemCount > 1) {
                                      setState(() {
                                        itemCount--;
                                      });
                                    }
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.minus,
                                    size: 10,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.green.shade900,
                                      primary: Colors.lightGreen.shade50,
                                      onSurface: Colors.grey.shade600,
                                      minimumSize: Size(30, 30),
                                      elevation: 0.0),
                                ),
                                Text(
                                  itemCount.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      itemCount++;
                                    });
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: 10,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.green.shade900,
                                      primary: Colors.lightGreen.shade50,
                                      minimumSize: Size(30, 30),
                                      onSurface: Colors.grey.shade600,
                                      elevation: 0.0),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (auth.currentUser != null) {
                                      cartController.addItems(widget.item, itemCount);
                                      // print(widget.item);
                                    } else {
                                      // Navigator.pushNamed(context, SignInPage.routeName);
                                      Get.off(SignInPage());
                                    }
                                  },
                                  child: Text(
                                    'Thêm vào giỏ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Colors.green.shade900,
                                    minimumSize: Size(180, 50),
                                    onSurface: Colors.grey.shade600,
                                  ),
                                ),
                              ]),
                        );
                      }
                      if (snapshot.hasData ) {
                        final bill = snapshot.data;
                        if (bill?.isEmpty ) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            height: 90,
                            padding: EdgeInsets.all(20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (itemCount > 1) {
                                        setState(() {
                                          itemCount--;
                                        });
                                      }
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.minus,
                                      size: 10,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.green.shade900,
                                        primary: Colors.lightGreen.shade50,
                                        onSurface: Colors.grey.shade600,
                                        minimumSize: Size(30, 30),
                                        elevation: 0.0),
                                  ),
                                  Text(
                                    itemCount.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        itemCount++;
                                      });
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.plus,
                                      size: 10,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.green.shade900,
                                        primary: Colors.lightGreen.shade50,
                                        minimumSize: Size(30, 30),
                                        onSurface: Colors.grey.shade600,
                                        elevation: 0.0),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (auth.currentUser != null) {
                                        cartController.addItems(widget.item, itemCount);
                                        // print(widget.item);
                                      } else {
                                        // Navigator.pushNamed(context, SignInPage.routeName);
                                        Get.off(() =>SignInPage());
                                      }
                                    },
                                    child: Text(
                                      'Thêm vào giỏ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Colors.green.shade900,
                                      minimumSize: Size(180, 50),
                                      onSurface: Colors.grey.shade600,
                                    ),
                                  ),
                                ]),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
              ),
              Positioned(
                  top: 30,
                  child: ElevatedButton(
                    child: Icon(
                      Icons.clear,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.black54.withOpacity(0.3),
                        shape: CircleBorder(),
                        minimumSize: Size(30, 30),
                        elevation: 0.0),
                  ))
            ],
          ),
        ),
      ),
    );
  }

}

class _timeBox extends StatelessWidget {
  const _timeBox({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      // controller: controller,
      endTime: (item.endtime).millisecondsSinceEpoch + 1000,
      widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
        List<Widget> list = [];
        if (time == null) {
          list.add(Text(
            '00:00:00',
            style: TextStyle(color: Colors.white),
          ));
        }
        if (time != null) {
          if (time.hours != null) {
            list.add(Text(
              time.hours.toString() + ':',
              style: TextStyle(color: Colors.white),
            ));
          }
          if (time.min != null) {
            list.add(Text(
              time.min.toString() + ':',
              style: TextStyle(color: Colors.white),
            ));
          }
          if (time.sec != null) {
            list.add(Text(
              time.sec.toString(),
              style: TextStyle(color: Colors.white),
            ));
          }
        }

        return Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: list,
        );
      },
    );
  }
}
