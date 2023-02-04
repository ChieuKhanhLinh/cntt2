import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/views/fragments/auth/update_info.dart';
import '../../../controllers/handle_cart.dart';
import '../../../controllers/handle_user.dart';
import '../../../models/user.dart';
import 'change_password.dart';

class Profile extends StatefulWidget {

  static String routeName = '/profile';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final auth = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF40C800),
          title: const Text('Thông tin cá nhân'),
        ),
        body: Stack(
          children: [
            FutureBuilder<Users?>(
              future: HandleUser().readUserInfo(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text(' ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  return user == null? Center(child: Text('No User')): SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          SizedBox(
                            height: 300,
                            child: Image.network(user.urlImage, width: double.infinity, fit: BoxFit.contain),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'Tên người dùng',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  user.name,
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16,),
                          Text(
                            'Số điện thoại',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  user.phone,
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16,),
                          Text(
                            'Địa chỉ email',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  user.email,
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Row(
                            children: [
                              editButton(user),
                              Spacer(),
                              ChangePassword(),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ));
  }

  Widget editButton(Users user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      height: 38,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.zero, color: Colors.white),
      child: ElevatedButton(
        onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateInfo(user: user,)),
              );
        } ,
        child: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Color(0xFF025B05))),
      ),
    );
  }
}



class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      height: 38,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.zero, color: Colors.white),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePass()),
          );
        } ,
        child: const Text(
          'Đổi mật khât khẩu',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Color(0xFF025B05))),
      ),
    );
  }
}