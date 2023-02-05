import 'package:flutter/material.dart';

class ChangeAddress extends StatefulWidget {
  static String routeName = '/change-address';
  final String address;

  const ChangeAddress({Key? key, required this.address}) : super(key: key);

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.address;
  }

  late String newAddress;

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
            Navigator.pop(context, widget.address);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Cập nhật địa chỉ',
                border: OutlineInputBorder(),
              ),
              controller: textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bạn chưa nhập địa chỉ mới';
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
                    final newAddress = textController.text;
                    Navigator.pop(context, newAddress);
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
    );
  }
}
