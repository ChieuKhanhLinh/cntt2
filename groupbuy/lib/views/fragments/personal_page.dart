import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/controllers/handle_user.dart';
import 'package:groupbuy/controllers/menu_items_data.dart';
import 'package:groupbuy/models/menu_item.dart';
import 'package:groupbuy/views/fragments/auth/profile.dart';
import 'package:groupbuy/views/fragments/auth/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuy/controllers/handle_auth.dart';
import 'package:groupbuy/views/fragments/auth/update_info.dart';
import 'package:groupbuy/views/fragments/bill_info.dart';

import '../../models/user.dart';
import 'admin/expired_item.dart';
import 'admin/item_option.dart';
import 'admin/manage_bill.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key? key}) : super(key: key);
  static String routeName = '/personalPage';

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Header(),
            Body(),
          ],
        ),
      ),
    );
  }

  Widget Header() {
    return Container(
      // color: Colors.white,
      width: double.infinity,
      height: (MediaQuery.of(context).size.height) * 0.25,
      child: Stack(
        children: [
          Positioned(
            top: (MediaQuery.of(context).size.height) * 0.12,
            bottom: 0,
            right: 10,
            left: 10,
            child: Container(
              height: 95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
              top: (MediaQuery.of(context).size.height) * 0.05,
              left: 17,
              child: FutureBuilder<Users?>(
                future: HandleUser().readUserInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print('${snapshot.error}');
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        Auth().currentUser?.photoURL ??
                            'https://firebasestorage.googleapis.com/v0/b/groupbuy-1ec04.appspot.com/o/image%2Fdefault_ava.jpg?alt=media&token=f0ed2a8b-952c-46bc-8256-825e13873d87',
                        height: 99,
                        width: 95,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    if (Auth().currentUser?.photoURL != null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.network(
                          Auth().currentUser?.photoURL ??
                              'https://firebasestorage.googleapis.com/v0/b/groupbuy-1ec04.appspot.com/o/image%2Fdefault_ava.jpg?alt=media&token=f0ed2a8b-952c-46bc-8256-825e13873d87',
                          height: 99,
                          width: 95,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    final user = snapshot.data;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        user.urlImage ??
                            'https://firebasestorage.googleapis.com/v0/b/groupbuy-1ec04.appspot.com/o/image%2Fdefault_ava.jpg?alt=media&token=f0ed2a8b-952c-46bc-8256-825e13873d87',
                        height: 99,
                        width: 95,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
          Positioned(
              top: (MediaQuery.of(context).size.height) * 0.15,
              left: 120,
              child: FutureBuilder<Users?>(
                future: HandleUser().readUserInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print('${snapshot.error}');
                  }
                  if (Auth().currentUser?.photoURL != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Auth().currentUser?.displayName ?? 'Tên người dùng',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          Auth().currentUser?.phoneNumber ?? ' ',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                color: Color(0xFF025B05),
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        )
                      ],
                    );
                  }
                  final user = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user == null
                          ? Text(
                              'Chào bạn',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            )
                          : Text(
                              user.name,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            ),
                      SizedBox(
                        height: 8.0,
                      ),
                      user == null
                          ? Text(
                              'Đăng nhập nào!',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    color: Color(0xFF025B05),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                            )
                          : Text(
                              user.phone,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    color: Color(0xFF025B05),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ),
                    ],
                  );
                },
              )),
          Positioned(
              top: (MediaQuery.of(context).size.height) * 0.15,
              right: 3,
              child: FutureBuilder<Users?>(
                future: HandleUser().readUserInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    print('${snapshot.error}');
                  }
                  if (Auth().currentUser?.photoURL != null) {
                    return Center(
                      child: PopupMenuButton<MoreItem>(
                        onSelected: (item) => onSelected(context, item),
                        itemBuilder: (context) => [
                          ...MenuItems().GoogleAccount.map(buildItem).toList()
                        ],
                      ),
                    );
                  }
                  final user = snapshot.data;
                  return Center(
                    child: PopupMenuButton<MoreItem>(
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                        if (user != null && user.role == 'admin')
                          ...MenuItems().AdminMenu.map(buildItem).toList()
                        else if (user != null && user.role == 'user')
                          ...MenuItems().UserList.map(buildItem).toList()
                        else
                          ...MenuItems().loginList.map(buildItem).toList()
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  PopupMenuItem<MoreItem> buildItem(MoreItem item) => PopupMenuItem<MoreItem>(
        value: item,
        child: Row(
          children: [
            Icon(
              item.icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(
              width: 14,
            ),
            Text(item.text),
          ],
        ),
      );

  void onSelected(BuildContext context, MoreItem item) {
    switch (item) {
      case MenuItems.itemEdit:
        Navigator.pushNamed(context, Profile.routeName);
        break;

      case MenuItems.itemOption:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemOptionPage()),
        );
        break;

      case MenuItems.itemExpired:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemExpiredPage()),
        );
        break;

      case MenuItems.itemLogin:
        Navigator.pushNamed(context, SignInPage.routeName);
        break;

      case MenuItems.itemLogout:
        Auth().signOut();
        Navigator.of(context).pushNamed('/');
        break;
    }
  }

  Widget Body() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height) * 0.06,
          ),
          Text(
            'Cập nhật thông tin',
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                  color: Color(0xFF013003),
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          OrderStatus(),
          SizedBox(
            height: 9,
          ),
          if (auth.currentUser != null)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data['role'] == 'user') {
                    return billInfo();
                  }
                  return Container();
                }
                return Container();
              },
            ),
          if (auth.currentUser != null)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data['role'] == 'admin') {
                    return manageBill();
                  }
                  return Container();
                }
                return Container();
              },
            ),
          SizedBox(
            height: 9,
          ),
          appInfo(),
          SizedBox(
            height: 9,
          ),
        ],
      ),
    );
  }

  Widget OrderStatus() {
    return Container(
      height: 69,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/choxuly.png'),
                iconSize: 30,
              ),
              Text(
                'Chờ xử lý',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/donggoi.png'),
                iconSize: 30,
              ),
              Text(
                'Đóng gói',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/vanchuyen.png'),
                iconSize: 30,
              ),
              Text(
                'Vận chuyển',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/nhanhang.png'),
                iconSize: 30,
              ),
              Text(
                'Nhận hàng',
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget billInfo() {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BillInfoPage()),
        );
      }),
      child: Container(
        height: 69,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Order.png',
              scale: 0.8,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Xem đơn hàng',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            Spacer(),
            Icon(
              Icons.navigate_next_rounded,
              size: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget manageBill() {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageBillPage()),
        );
      }),
      child: Container(
        height: 69,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Order.png',
              scale: 0.8,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Quản lý đơn hàng',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            Spacer(),
            Icon(
              Icons.navigate_next_rounded,
              size: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget appInfo() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 69,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Paper.png',
              scale: 0.8,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Thông tin ứng dụng',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            Spacer(),
            Icon(
              Icons.navigate_next_rounded,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
