import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class HandleUser {
  final auth = FirebaseAuth.instance;


  // Read userInfo
  Future<Users?> readUserInfo() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid);
    final snapshot = await docUser.get();
    if(snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
    return null;
  }

  // Update user
  Future updateUser(Users user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid);
    final json = user.toJson();
    await docUser.update(json);
  }

  //Set user Info from database
  Future userInfo({
    String? username,
    String? phone,
  }) async {
    String email = auth.currentUser!.email.toString();
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({
      'name': username,
      'phone': phone,
      'email': email,
      'address': '',
      'role': 'user',
      'urlImage': 'https://firebasestorage.googleapis.com/v0/b/groupbuy-1ec04.appspot.com/o/image%2Fdefault_ava.jpg?alt=media&token=f0ed2a8b-952c-46bc-8256-825e13873d87',
    });
  }

  // Update user's email on Authentication
  Future updateUserEmail({
    required String yourConfirmPassword,
    required String newEmail,
  }) async {
    final oldEmail = auth.currentUser!.email;
    await auth
        .signInWithEmailAndPassword(
        email: oldEmail!, password: yourConfirmPassword)
        .then((userCredential) async { await
    userCredential.user!.updateEmail(newEmail);
    });
  }

  // Update user's password on Authentication
  Future updateUserPassword({
    required String yourConfirmPassword,
    required String newPassword,
  }) async {
    final oldEmail = auth.currentUser!.email;
    await auth
        .signInWithEmailAndPassword(
        email: oldEmail!, password: yourConfirmPassword)
        .then((userCredential) {
      userCredential.user!.updatePassword(newPassword);
    });
  }
}
