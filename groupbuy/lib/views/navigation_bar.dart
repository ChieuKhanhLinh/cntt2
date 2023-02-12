import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'fragments/homepage.dart';
import 'fragments/order_page.dart';
import 'fragments/personal_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  static const routeName = '/';
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  List<Widget> screens = <Widget>[HomePage(), OrderPage(), PersonalPage()];

  void updateIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: screens[currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: updateIndex,
          selectedItemColor: Color.fromARGB(1000, 64, 200, 0),
          selectedFontSize: 13,
          unselectedFontSize: 13,
          iconSize: 30,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              label: "Trang chủ",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Giỏ hàng",
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: "Cá nhân",
              icon: Icon(Icons.person),
            ),
          ]),
    );
  }
}
