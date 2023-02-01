import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupbuy/controllers/menu_items_data.dart';
import 'package:groupbuy/models/menu_item.dart';
import 'package:groupbuy/views/fragments/admin/item_option.dart';
import 'package:groupbuy/views/fragments/auth/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuy/controllers/handle_auth.dart';
import 'package:groupbuy/views/fragments/homepage.dart';


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
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Color(0xFF40C800),
    //     iconTheme: IconThemeData(color: Colors.white),
    //     elevation: 0,
    //     title: Text('Trang cá nhân'),
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: SafeArea(
    //     child: Container(
    //       padding: EdgeInsets.all(10),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           if (auth.currentUser == null)
    //             TextButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, SignInPage.routeName);
    //                 },
    //                 child: Text('Đăng nhập')),
    //           if (auth.currentUser != null) Text(user?.email ?? 'User email'),
    //           if (auth.currentUser != null)
    //             TextButton(
    //                 onPressed: () {
    //                   Auth().signOut();
    //                   Navigator.of(context).pushNamed('/');
    //                 },
    //                 child: Text('Đăng xuất')),
    //           SizedBox(
    //             height: 24,
    //           ),
    //           if (auth.currentUser != null)
    //             StreamBuilder(
    //                 stream: FirebaseFirestore.instance
    //                     .collection('users')
    //                     .doc(auth.currentUser!.uid)
    //                     .snapshots(),
    //                 builder: (context, AsyncSnapshot snapshot) {
    //                   if (snapshot.hasError) {
    //                     return Container();
    //                   }
    //                   if (snapshot.hasData && snapshot.data != null) {
    //                     if (snapshot.data['role'] == 'admin') {
    //                       return ListTile(
    //                         onTap: () {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (context) =>
    //                                 const ItemOptionPage()),
    //                           );
    //                         },
    //                         leading: const Icon(
    //                           Icons.wysiwyg_rounded,
    //                           color: Colors.black,
    //                         ),
    //                         title: const Text('Tùy chọn sản phẩm'),
    //                         trailing: const Icon(
    //                           Icons.arrow_forward_ios_rounded,
    //                           color: Colors.grey,
    //                           size: 18,
    //                         ),
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(6)),
    //                         tileColor: Colors.white,
    //                         contentPadding: EdgeInsets.symmetric(
    //                             vertical: 5, horizontal: 10),
    //                       );
    //                     }
    //                   } else {
    //                     return Container();
    //                   }
    //                   return Container();
    //                 }),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return SafeArea(
      child: Scaffold(
        body: ListView (
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
      height: (MediaQuery.of(context).size.height)*0.25,
      child: Stack(
        children: [
          Positioned(
            top: (MediaQuery.of(context).size.height)*0.12,
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
          if (user?.photoURL == null) Positioned(
            top: (MediaQuery.of(context).size.height)*0.05,
            left: 17,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child:
              Image.asset('assets/raidencute.jpg', height: 99, width: 95,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (user?.photoURL != null) Positioned(
            top: (MediaQuery.of(context).size.height)*0.05,
            left: 17,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child:
              Image.network(user?.photoURL ?? 'https://picsum.photos/250?image=9', height: 99, width: 95,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height)*0.15,
            left: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (auth.currentUser == null) Text(
                  'Chào bạn',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
                if (auth.currentUser != null) Text(
                  user?.displayName ?? 'Tên người dùng',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
                SizedBox(height: 8,),
                if (auth.currentUser != null) Text(
                  user?.phoneNumber ?? 'Cập nhật số điện thoại nào!',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(color: Color(0xFF025B05), fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height)*0.15,
            right: 3,
            child: Center(
              child: PopupMenuButton<MoreItem>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  if (auth.currentUser != null)
                    ...MenuItems().logoutList.map(buildItem).toList()
                  else
                    ...MenuItems().loginList.map(buildItem).toList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<MoreItem> buildItem (MoreItem item) => PopupMenuItem<MoreItem>(
    value: item,
    child: Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 20,),
        const SizedBox(width: 14,),
        Text(item.text),
      ],
    ),
  );

  void onSelected(BuildContext context, MoreItem item) {
    switch (item) {
      case MenuItems.itemEdit:
          print(user.toString());
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

    List imgList = [
      'assets/choxuly.png',
      'assets/donggoi.png',
      'assets/vanchuyen.png',
      'assets/nhanhang.png',
    ];

    List itemsName = [
      'Chờ xử lý',
      'Đóng gói',
      'Vận chuyển',
      'Nhận hàng',
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: (MediaQuery.of(context).size.height)*0.06,),
          Text(
            'Cập nhật thông tin',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Color(0xFF013003), fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
          SizedBox(height: 12,),
          OrderStatus(),
          SizedBox(height: 9,),
          Address(),
          SizedBox(height: 9,),
          Info(),
          SizedBox(height: 9,),
          MemberInfo(),
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
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
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
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
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
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
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
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Address() {
    return Container(
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
          Image.asset('assets/Order.png',scale: 0.8,),
          SizedBox(width: 8,),
          Text(
            'Địa chỉ nhận hàng',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
          Spacer(),
          Icon(Icons.navigate_next_rounded,size: 30,)
        ],
      ),
    );
  }

  Widget Info() {
    return Container(
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
          Image.asset('assets/Paper.png',scale: 0.8,),
          SizedBox(width: 8,),
          Text(
            'Thông tin đơn hàng đã đặt',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
          Spacer(),
          Icon(Icons.navigate_next_rounded,size: 30,)
        ],
      ),
    );
  }

  Widget MemberInfo() {
    return Container(
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
          Image.asset('assets/Message.png',scale: 0.8,),
          SizedBox(width: 8,),
          Text(
            'Thông tin về các thành viên ',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16, ),
            ),
          ),
          Spacer(),
          Icon(Icons.navigate_next_rounded,size: 30,)
        ],
      ),
    );
  }

}
