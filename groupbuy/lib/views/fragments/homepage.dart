import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:groupbuy/models/items.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'item_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF40C800),
        automaticallyImplyLeading: false,
        title: Text('Trang Chủ'),
      ),
      body: ListView(padding: EdgeInsets.all(20), children: [
        shopBanner(),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              'Phiên hết hạn sau:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF013003)),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        StreamBuilder<List<Item>>(
          stream: readItems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            }
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    mainAxisExtent: 310),
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: items.map(_buildItem).toList(),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ]),
    );
  }

  Widget _buildItem(Item item) {
    return Stack(
      children: [
        // if (item.status != 0)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Detail(item: item)),
              );
            },
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: NetworkImage(item.imgLink),
                          fit: BoxFit.contain),
                    ),
                  ),
                  if (item.ordered == item.totalorder)
                    Positioned(
                      top: 40,
                      left: 20,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        height: 65,
                        decoration: BoxDecoration(
                            color: Color(0xFF202020),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'Hết lượt mua',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: const Color(0xFFE7E7E7),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.name.toUpperCase(),
                          style: TextStyle(fontSize: 13, color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          NumberFormat.currency(locale: 'vi')
                              .format(item.minprice),
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF40C800),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      timeBox(item: item),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          item.ordered.toString() + ' người đã đặt mua',
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Stream<List<Item>> readItems() => FirebaseFirestore.instance
      .collection('items')
      .orderBy('name')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());
}

class shopBanner extends StatefulWidget {
  const shopBanner({Key? key}) : super(key: key);
  State<shopBanner> createState() => _shopBannerState();
}

class _shopBannerState extends State<shopBanner> {
  int activeIndex = 0;
  final imgBanner = [
    'assets/home/banner1.jpg',
    'assets/home/banner2.jpg',
    'assets/home/banner3.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: imgBanner.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final _imgBanner = imgBanner[index];
              return buildImage(_imgBanner, index);
            },
            options: CarouselOptions(
              height: 150,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 7,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
              onPageChanged: (index, reaspn) =>
                  setState(() => activeIndex = index),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildImage(String imgBanner, int index) => Container(
          child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //set border radius to 50% of square height and width
          image: DecorationImage(
            image: AssetImage(imgBanner),
            fit: BoxFit.cover, //change image fill type
          ),
        ),
      ));

  buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: imgBanner.length,
        effect: SlideEffect(
            spacing: 5.0,
            radius: 4.0,
            dotWidth: 10.0,
            dotHeight: 2.0,
            dotColor: Colors.grey.shade300,
            activeDotColor: Colors.grey),
      );
}

class timeBox extends StatelessWidget {
  const timeBox({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CountdownTimer(
        // controller: controller,
        endTime: (item.endtime).millisecondsSinceEpoch + 1000,
        widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {
          List<Widget> list = [];
          if (time == null) {
            list.add(Text(
              '00:00:00',
              style: TextStyle(color: Colors.white),
            ));
          }
          if (time != null) {
            if (time.days != null) {
              list.add(Text(
                time.days.toString() + ' ngày ',
                style: TextStyle(color: Colors.white),
              ));
            } else {
              list.add(Text(
                ' 0 ngày ',
                style: TextStyle(color: Colors.white),
              ));
            }
            if (time.hours != null) {
              list.add(Text(
                time.hours.toString() + ':',
                style: TextStyle(color: Colors.white),
              ));
            }
            if (time.min != null) {
              list.add(Text(
                time.min.toString() + ':',
                style: TextStyle(color: Colors.white),
              ));
            }
            if (time.sec != null) {
              list.add(Text(
                time.sec.toString(),
                style: TextStyle(color: Colors.white),
              ));
            }
          }

          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange.shade700),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: list,
            ),
          );
        },
      ),
    );
  }
}
