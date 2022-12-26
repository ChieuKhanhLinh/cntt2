import 'package:flutter/material.dart';
import 'package:groupbuy/views/navigation_bar.dart';

import 'fragments/auth/sign_in_page.dart';
import 'fragments/auth/sign_up_page.dart';
import 'fragments/group_page.dart';
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
          primarySwatch: Colors.lightGreen,
          scaffoldBackgroundColor: Color(0xFFDCEFD3)),
      routes: {
        '/': (context) => NavBar(),
        '/homePage': (context) => const HomePage(),
        '/personalPage': (context) => PersonalPage(),
        '/signInPage': (context) => const SignInPage(),
        '/signUpPage': (context) => const SignUpPage(),
      },
      initialRoute: '/',
    );
  }
}
