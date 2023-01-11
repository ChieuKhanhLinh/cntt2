import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groupbuy/views/fragments/admin/add_item.dart';
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
  final User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF40C800),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text('Trang cá nhân'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (auth.currentUser == null)
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignInPage.routeName);
                    },
                    child: Text('Đăng nhập')),
              if (auth.currentUser != null) Text(user?.email ?? 'User email'),
              if (auth.currentUser != null)
                TextButton(
                    onPressed: () {
                      Auth().signOut();
                      Navigator.of(context).pushNamed('/');
                    },
                    child: Text('Đăng xuất')),
              if (auth.currentUser != null)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddItemPage()),
                    );
                  },
                  child: Text('Tùy chọn sản phẩm'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
