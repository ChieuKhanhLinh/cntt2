import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:groupbuy/models/items.dart';
import 'package:groupbuy/views/fragments/check_out_page.dart';
import '../../controllers/handle_cart.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);
  static const String routeName = '/orderPage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final CartController controller = Get.find();

  late final Item item;
  late final int quantity;
  late final int index;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF40C800),
            elevation: 1,
            title: const Text('Giỏ hàng'),
            actions: [
              TextButton(
                  onPressed: () {
                    controller.items.clear();
                    Navigator.of(context).pushNamed('/');
                  },
                  child: Text(
                    'Xóa giỏ hàng',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )),
            ],
            centerTitle: true,
          ),
          body: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: Colors.grey.shade300))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.items.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.items.keys.toList()[index].name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 6.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      NumberFormat.currency(locale: 'vi')
                                          .format(controller.items.keys
                                              .toList()[index]
                                              .minprice),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.removeItem(controller
                                            .items.keys
                                            .toList()[index]);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          onPrimary: Colors.white,
                                          primary: Color(0xFF40C800),
                                          onSurface: Colors.grey.shade600,
                                          minimumSize: const Size(30, 30),
                                          elevation: 0.0),
                                      child: const FaIcon(
                                          FontAwesomeIcons.minus,
                                          size: 10),
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      controller.items.values
                                          .toList()[index]
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        controller.addItem(controller.items.keys
                                            .toList()[index]);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          onPrimary: Colors.white,
                                          primary: Color(0xFF40C800),
                                          minimumSize: const Size(30, 30),
                                          onSurface: Colors.grey.shade600,
                                          elevation: 0.0),
                                      child: const FaIcon(
                                        FontAwesomeIcons.plus,
                                        size: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: 90,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: (controller.items.length == 0 ||
                                  auth.currentUser == null)
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckOut()));
                                },
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Color(0xFF40C800),
                            minimumSize: const Size(180, 50),
                            onSurface: Colors.grey.shade600,
                          ),
                          // onPressed: null,
                          child: Row(
                            // style: TextStyle(fontSize: 16),
                            children: [
                              Text('${controller.items.length} sản phẩm'),
                              Spacer(),
                              Text('Thanh toán'),
                              Spacer(),
                              // Text(controller.total.toString()),
                              Text(NumberFormat.currency(locale: 'vi')
                                  .format(controller.total))
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}
