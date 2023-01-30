import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuy/models/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dotted_border/dotted_border.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({Key? key, required this.item}) : super(key: key);
  final Item item;
  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final controllerName = TextEditingController();
  final controllerDetail = TextEditingController();
  final controllerInitialPrice = TextEditingController();
  final controllerMinPrice = TextEditingController();
  final controllerTotalOrder = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? initialImgLink;

  @override
  void initState() {
    super.initState();
    controllerName.text = widget.item.name;
    controllerDetail.text = widget.item.detail;
    controllerInitialPrice.text = widget.item.initialprice.toString();
    controllerMinPrice.text = widget.item.minprice.toString();
    controllerTotalOrder.text = widget.item.totalorder.toString();
    initialImgLink = widget.item.imgLink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa sản phẩm'),
        elevation: 0,
        backgroundColor: Color(0xFF40C800),
      ),
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
              if (pickedFile == null ||
                  (initialImgLink == null && initialImgLink == ''))
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
              const SizedBox(height: 24),
              TextFormField(
                decoration: decoration("Tên sản phẩm"),
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
                maxLines: 12,
                decoration: decoration('Chi tiết sản phẩm'),
                controller: controllerDetail,
              ),
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
                // initialValue: TextEditingController(widget.item.totalorder.toString()),
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
                      if (initialImgLink != null && initialImgLink != '') {
                        final item = Item(
                          id: widget.item.id,
                          name: controllerName.text,
                          detail: controllerDetail.text,
                          initialprice: int.parse(controllerInitialPrice.text),
                          minprice: int.parse(controllerMinPrice.text),
                          totalorder: int.parse(controllerTotalOrder.text),
                          imgLink: initialImgLink ?? '',
                        );
                        updateItem(item);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '"${controllerName.text}" has been updated successfully!')));
                        Navigator.of(context).pop();
                        return;
                      }

                      final imgLink = await uploadFile();
                      final item = Item(
                        id: widget.item.id,
                        name: controllerName.text,
                        detail: controllerDetail.text,
                        initialprice: int.parse(controllerInitialPrice.text),
                        minprice: int.parse(controllerMinPrice.text),
                        totalorder: int.parse(controllerTotalOrder.text),
                        imgLink: imgLink,
                      );
                      updateItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color(0xFF013003),
                          content: Text(
                              '"${controllerName.text}" đã được sửa thành công!')));
                      Navigator.of(context).pop();
                      return;
                    }
                  },
                  child: const Text(
                    'Chỉnh sửa sản phẩm',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF013003))),
                ),
              )
            ],
          )),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future updateItem(Item item) async {
    final docItem = FirebaseFirestore.instance.collection('items').doc(item.id);
    final json = item.toJson();
    await docItem.update(json);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null) return;

    setState(() {
      initialImgLink = null;
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
