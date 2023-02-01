import 'package:flutter/material.dart';
import 'package:groupbuy/models/menu_item.dart';

class MenuItems {

  List<MoreItem> logoutList = [
    itemEdit,
    itemLogout,
  ];

  List<MoreItem> loginList = [
    itemLogin,
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