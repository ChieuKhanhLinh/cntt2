import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../controllers/handle_auth.dart';
import '../../../controllers/handle_user.dart';
import '../../../validate/validation.dart';

class ChangePass extends StatefulWidget {

  static String routeName = '/changePass';

  const ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> with CommonValidation {

  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  late String _oldPassword, _newPassword;

  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF40C800),
          title: Text("Cập nhật thông tin cá nhân")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mật khẩu cũ',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _oldPasswordVisible? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _oldPasswordVisible = !_oldPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: _oldPasswordVisible,
              controller: oldPasswordController,
              validator: validateEditOldPassword,
              onChanged: (value) {
                setState(() {
                  _oldPassword = value.trim();
                });
              },
            ),
            SizedBox(height: 32,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _newPasswordVisible? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _newPasswordVisible = !_newPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: _newPasswordVisible,
              controller: newPasswordController,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Bạn chưa xác nhận mật khẩu của mình.';
                }
                if (_oldPassword == _newPassword) {
                  return 'Mật khẩu mới giống với mật khẩu hiện tai!';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _newPassword = value.trim();
                });
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              height: 46.0,
              child: ElevatedButton(
                onPressed: ()  async {
                  try {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      await HandleUser().updateUserPassword(
                          yourConfirmPassword: _oldPassword, newPassword: _newPassword);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color(0xFF025B05),
                          content: Text('Cập nhật mật khẩu thành công!')));
                      Auth().signOut();
                      Navigator.popAndPushNamed(context, '/');
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(20),
                        content: Text("Sai mật khẩu, vui lòng thử lại!"),
                      ));
                    }
                  }
                },
                child: const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFF025B05))),
              ),
            )
          ],
        ),
      ),
    );
  }

}
