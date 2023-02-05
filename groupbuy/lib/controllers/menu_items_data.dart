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
    itemOption,
    itemExpired,
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
    text: 'Hồ sơ',
    icon: Icons.person_outline,
  );

  static const itemOption = MoreItem(
    text: 'Tùy chọn sản phẩm',
    icon: Icons.edit_attributes_outlined,
  );

  static const itemExpired = MoreItem(
    text: 'Sản phẩm hết hạn',
    icon: Icons.edit_attributes_outlined,
  );
}
