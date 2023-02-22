import 'package:flutter/material.dart';

class ChangeAddress extends StatefulWidget {
  static String routeName = '/change-address';
  final String address;
  final String phone;

  const ChangeAddress({Key? key, required this.address, required this.phone}) : super(key: key);

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    addressController.text = widget.address;
    phoneController.text = widget.phone;
  }

  late String newAddress;
  late String newPhone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF40C800),
        title: Text("Đổi địa chỉ giao hàng"),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context,[widget.address, widget.phone]);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cập nhật địa chỉ - Số nhà - Tên đường - Quận huyện',
                  border: OutlineInputBorder(),
                ),
                controller: addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bạn chưa nhập địa chỉ mới';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cập nhật số điện thoại',
                  border: OutlineInputBorder(),
                ),
                controller: phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bạn chưa nhập số điện thoại';
                  }
                  return null;
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SizedBox(
                  height: 46.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        final newAddress = addressController.text;
                        final newPhone = phoneController.text;
                        Navigator.pop(context, [newAddress, newPhone]);
                        print([newAddress, newPhone]);
                      }


                    },
                    child: const Text(
                      'Cập nhật địa chỉ',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF025B05))),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
