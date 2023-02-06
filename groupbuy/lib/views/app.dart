import 'package:flutter/material.dart';
import 'package:groupbuy/views/fragments/admin/expired_item.dart';
import 'package:groupbuy/views/fragments/admin/manage_bill.dart';
import 'package:groupbuy/views/fragments/auth/change_password.dart';
import 'package:groupbuy/views/fragments/auth/profile.dart';
import 'package:groupbuy/views/fragments/bill_info.dart';
import 'package:groupbuy/views/fragments/check_out_page.dart';
import 'package:groupbuy/views/navigation_bar.dart';

import 'fragments/admin/item_option.dart';
import 'fragments/auth/sign_in_page.dart';
import 'fragments/auth/sign_up_page.dart';
import 'fragments/auth/forgot_pw_page.dart';
import 'fragments/auth/update_info.dart';
import 'fragments/change_address.dart';
import 'fragments/homepage.dart';
import 'fragments/order_page.dart';
import 'fragments/personal_page.dart';
import 'navigation_bar.dart';

class GroupbuyApp extends StatelessWidget {
  const GroupbuyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groupbuy App',
      theme: ThemeData(
          // This is the theme of application.
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Color(0xFFDCEFD3)),
      routes: {
        '/': (context) => NavBar(),
        '/homePage': (context) => const HomePage(),
        '/personalPage': (context) => PersonalPage(),
        '/signInPage': (context) => const SignInPage(),
        '/signUpPage': (context) => const SignUpPage(),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
        '/itemOptionPage': (context) => const ItemOptionPage(),
        '/expiredItem': (context) => const ItemExpiredPage(),
        '/manageBill': (context) => const ManageBillPage(),
        '/profile': (context) => const Profile(),
        '/changePass': (context) => const ChangePass(),
        '/check-out': (context) => const CheckOut(),
        '/billInfo': (context) => const BillInfoPage(),
      },
      initialRoute: '/',
    );
  }
}
