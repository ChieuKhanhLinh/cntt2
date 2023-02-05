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
                      onTap: () {

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
                            'Bạn chưa nhập địa chỉ nào cả',
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
            ],
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
}
