import 'package:flutter/material.dart';
import 'package:groupbuy/models/items.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuy/models/menu_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_item.dart';
import 'edit_item.dart';

class ItemOptionPage extends StatefulWidget {
  const ItemOptionPage({Key? key}) : super(key: key);
  static const String routeName = '/itemOptionPage';

  @override
  State<ItemOptionPage> createState() => _ItemOptionPageState();
}

class _ItemOptionPageState extends State<ItemOptionPage> {
  final auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tùy chọn sản phẩm'),
        elevation: 0,
        backgroundColor: Color(0xFF40C800),
      ),
      body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddItemPage()),
                  );
                },
                child: RichText(
                    text: TextSpan(children: [
                  WidgetSpan(
                      child: Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: Color(0xFF025B05),
                  )),
                  TextSpan(
                      text: "Thêm sản phẩm",
                      style: TextStyle(
                          color: Color(0xFF025B05),
                          fontSize: 17,
                          fontWeight: FontWeight.w500))
                ])),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Sản phẩm đã thêm",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF013003)),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<List<Item>>(
              stream: readItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final items = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: items.map(_builderItem).toList(),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ]),
    );
  }

  Widget _builderItem(Item item) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditItemPage(item: item)),
                    );
                  },
                  backgroundColor: Color.fromARGB(255, 25, 211, 155),
                  foregroundColor: Colors.white,
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (BuildContext slidableContext) async {
                    final confirmed = await confirm(
                      context,
                      title: const Text('Confirm'),
                      content: Text(
                          'Bạn có chắc muốn xóa "${item.name}" khỏi danh sách?'),
                      textOK: const Text(
                        'Có',
                        style: TextStyle(color: Colors.red),
                      ),
                      textCancel: const Text('Quay lại'),
                    );
                    print(confirmed);
                    if (confirmed) {
                      final docItem = FirebaseFirestore.instance
                          .collection('items')
                          .doc(item.id);
                      docItem.delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              '"${item.name}" has been removed successfully!')));
                    }
                    print('pressedCancel');
                    return;
                  },
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(width: 1.0, color: Colors.grey.shade300))),
              height: 140.0,
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                          Text(
                            item.detail,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: false,
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(locale: 'vi')
                                .format(item.minprice),
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.green),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              const Icon(
                                Icons.access_alarm_outlined,
                                color: Colors.indigo,
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(item.endtime),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    if (item.imgLink != '')
                      Container(
                        width: 100.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: NetworkImage(item.imgLink),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ]),
            ),
          ),
        ),
        if (item.ordered == item.totalorder)
          Positioned(
              right: 0,
              child: Container(
                width: 70,
                color: Colors.green,
                child: Center(
                    child: Text(
                  'Thành công',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                )),
              )),
      ],
    );
  }

  Stream<List<Item>> readItems() => FirebaseFirestore.instance
      .collection('items')
      .where('endtime', isGreaterThan: now)
      .orderBy('endtime')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());
}
