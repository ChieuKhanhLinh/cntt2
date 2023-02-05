import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuy/models/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

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
  final controllerEndTime = TextEditingController();

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
          padding: EdgeInsets.all(10),
          children: [
            if (pickedFile != null)
              SizedBox(
                height: 300,
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            if (pickedFile == null)
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
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
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
            SizedBox(height: 24),
            TextFormField(
              decoration: decoration(
                'Thời gian kết thúc',
              ),
              controller: controllerEndTime,
              onTap: () async {
                TimeOfDay time = TimeOfDay.now();
                FocusScope.of(context).requestFocus(new FocusNode());
                TimeOfDay? picked =
                    await showTimePicker(context: context, initialTime: time);
                if (picked != null && picked != time) {
                  DateTime now = DateTime.now();
                  var dt = DateTime(
                      now.year, now.month, now.day, picked.hour, picked.minute);
                  controllerEndTime.text =
                      DateFormat('yyyy-MM-dd HH:mm').format(dt);
                  setState(() {
                    time = picked;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'cant be empty';
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
                      endtime: DateTime.parse(controllerEndTime.text),
                    );
                    addItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Color(0xFF025B05),
                        content: Text(
                            '"${controllerName.text}" đã lưu thành công!')));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Thêm sản phẩm',
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
