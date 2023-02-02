import 'package:flutter/material.dart';
import 'package:groupbuy/models/menu_item.dart';

class MenuItems {

  List<MoreItem> loginList = [
    itemLogin,
  ];

  List<MoreItem> GoogleAccount = [
    itemLogout,
  ];

  List<MoreItem> UserList = [
    itemEdit,
    itemLogout,
  ];

  List<MoreItem> AdminMenu = [
    itemEdit,
    itemEdit,
    itemEdit,
    itemLogout,
  ];



  static const itemLogout = MoreItem(
      text: 'Đăng xuất',
      icon: Icons.logout_outlined,
  );

  static const itemLogin = MoreItem(
    text: 'Đăng nhập',
    icon: Icons.login_outlined,
  );

  static const itemEdit = MoreItem(
    text: 'Chỉnh sửa',
    icon: Icons.mode_edit_outline,
  );
}