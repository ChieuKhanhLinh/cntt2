import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _firebaseAuth.currentUser?.email;
    if (user!=null) {
      print('Đăng nhập thành công');
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _firebaseAuth.currentUser?.email;
    if (user != null) {
      print('Đăng ký thành công');
    }
  }

  signInWithGoogle() async {
    await GoogleSignIn().disconnect();
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    //create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print('Đăng nhập google thành công!');
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print('Đăng xuất thành công');
  }

}