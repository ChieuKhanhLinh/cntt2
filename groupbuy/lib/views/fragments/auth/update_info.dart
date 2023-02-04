import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuy/models/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/models/user.dart';

import '../../../controllers/handle_user.dart';
import '../../../validate/validation.dart';

class UpdateInfo extends StatefulWidget {

  static String routeName = '/updateInfo';
  final Users user;

  const UpdateInfo({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateInfo> createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> with CommonValidation {

  final controllerName = TextEditingController();
  final controlerPhone = TextEditingController();
  final controlerEmail = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late String userRole;
  late String confirmPassword;
  bool _passwordVisible = true;

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? initialImgLink;

  @override
  void initState() {
    super.initState();
    controllerName.text = widget.user.name;
    controlerPhone.text = widget.user.phone;
    controlerEmail.text = widget.user.email;
    userRole = widget.user.role;
    initialImgLink = widget.user.urlImage;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF40C800),
          title: Text("Cập nhật thông tin cá nhân")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            if (initialImgLink != '' && initialImgLink != null)
              SizedBox(
                height: 300,
                child: Image.network(
                  initialImgLink!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            if (pickedFile != null)
              SizedBox(
                height: 300,
                child: Image.file(File(pickedFile!.path!),
                    width: double.infinity, fit: BoxFit.contain),
              ),
            if (pickedFile == null &&
                (initialImgLink == null || initialImgLink == ''))
              GestureDetector(
                onTap: selectFile,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(5),
                  color: Colors.indigo,
                  dashPattern: [5, 5],
                  strokeWidth: 1,
                  padding: EdgeInsets.all(6),
                  child: Container(
                    color: Color(0xFFD9D9D9),
                    height: 300,
                    child: Center(
                      child: Icon(
                        Icons.camera_enhance,
                        size: 50,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ),
            if (pickedFile != null ||
                (initialImgLink != null && initialImgLink != ''))
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Color(0xFFff0f0f)),
                ),
                onPressed: () {
                  setState(() {
                    initialImgLink = null;
                    pickedFile = null;
                  });
                },
                child: Text('Xóa ảnh'),
              ),
            SizedBox(height: 24,),
            TextFormField(
              decoration: decoration('Họ Tên'),
              controller: controllerName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bạn chưa nhập tên mới';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Số điện thoại'),
              controller: controlerPhone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: validateSignUpPhone,
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Email'),
              controller: controlerEmail,
              validator: validateLoginEmail,
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu ',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: _passwordVisible,
              controller: confirmPasswordController,
              validator: validateEditOldPassword,
              onChanged: (value) {
                setState(() {
                  confirmPassword = value.trim();
                });
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              height: 46.0,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final imgLink = await uploadFile();
                      await HandleUser().updateUserEmail(
                          yourConfirmPassword: confirmPassword,
                          newEmail: controlerEmail.text);

                      if (initialImgLink != null && initialImgLink != '') {
                        final user = Users(
                          phone: controlerPhone.text,
                          email: controlerEmail.text,
                          name: controllerName.text,
                          role: userRole,
                          urlImage: initialImgLink ?? '',
                        );
                        HandleUser().updateUser(user,);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Color(0xFF025B05),
                            content: Text(
                                'Thông tin tài khoản đã cập nhật thành công !')));
                        Navigator.popAndPushNamed(context, '/');
                        return;
                      }

                      final user = Users(
                        phone: controlerPhone.text,
                        email: controlerEmail.text,
                        name: controllerName.text,
                        role: userRole,
                        urlImage: imgLink,
                      );
                      HandleUser().updateUser(user,);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color(0xFF025B05),
                          content: Text(
                              'Thông tin tài khoản đã cập nhật thành công !')));
                      Navigator.popAndPushNamed(context, '/');
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(20),
                        content: Text("Sai mật khẩu, vui lòng thử lại"),
                      ));
                    }
                    if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(20),
                        content: Text("Email xin lỗi đã tồn tại"),
                      ));
                    }
                  }
                } ,
                child: const Text(
                  'Cập nhật thông tin',
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

  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
  );

  Future addItem(Item item) async {
    final docItem = FirebaseFirestore.instance.collection('items').doc();
    item.id = docItem.id;
    final json = item.toJson();
    await docItem.set(json);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<String> uploadFile() async {
    if (pickedFile == null) {
      return '';
    }

    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
}


