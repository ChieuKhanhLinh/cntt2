import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuy/models/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final controllerName = TextEditingController();
  final controllerDetail = TextEditingController();
  final controllerMinPrice = TextEditingController();
  final controllerInitialPrice = TextEditingController();
  final controllerTotalOrder = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF40C800),
          title: Text("Thêm sản phẩm")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            if (pickedFile != null)
              SizedBox(
                height: 400,
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ElevatedButton(
                onPressed: selectFile,
                child: Text(
                  "Chọn ảnh",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF013003)))),
            if (pickedFile != null)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFff0f0f)),
                ),
                onPressed: () {
                  setState(() {
                    pickedFile = null;
                  });
                },
                child: Text('Xóa ảnh'),
              ),
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Tên sản phẩm'),
              controller: controllerName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bạn chưa điền tến sản phẩm!';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            TextFormField(
                minLines: 6,
                maxLines: 10,
                decoration: decoration('Chi tiết sản phẩm'),
                controller: controllerDetail),
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Giá gốc'),
              controller: controllerInitialPrice,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hãy điền giá gốc của sản phẩm!';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Giá thấp nhất'),
              controller: controllerMinPrice,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hãy điền giá thấp nhất của sản phẩm!';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Số người mua chung'),
              controller: controllerTotalOrder,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Hãy điền số người mua chung sản phẩm!';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              height: 46.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final imgLink = await uploadFile();
                    final item = Item(
                      name: controllerName.text,
                      detail: controllerDetail.text,
                      initialprice: int.parse(controllerInitialPrice.text),
                      minprice: int.parse(controllerMinPrice.text),
                      totalorder: int.parse(controllerTotalOrder.text),
                      imgLink: imgLink,
                    );
                    addItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                            '"${controllerName.text}" has been added successfully!')));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Thêm sản phẩm',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF013003))),
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
