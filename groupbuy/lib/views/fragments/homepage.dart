import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
            timeBox(),
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
              return Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      mainAxisExtent: 250),
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: items.map(_buildItem).toList(),
                ),
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
    return Container(
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
          // if (item.imgLink != '')
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                  image: NetworkImage(item.imgLink), fit: BoxFit.contain),
            ),
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
                      NumberFormat.currency(locale: 'vi').format(item.minprice),
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF40C800),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      item.ordered.toString() + ' sản phẩm đặt mua',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ]),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text(
            '24',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                background: Paint()
                  ..strokeWidth = 19
                  ..color = Color(0xFF013003)
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round),
          ),
          Spacer(),
          Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            '24',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                background: Paint()
                  ..strokeWidth = 19
                  ..color = Color(0xFF013003)
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round),
          ),
          Spacer(),
          Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            '24',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                background: Paint()
                  ..strokeWidth = 19
                  ..color = Color(0xFF013003)
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round),
          ),
        ],
      ),
    );
  }
}
