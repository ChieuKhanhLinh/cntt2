import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/validate/validation.dart';
import 'package:groupbuy/controllers/handle_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuy/views/fragments/auth/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String routeName = '/signInPage';
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<StatefulWidget> with CommonValidation {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String _email;
  late String _password;
  bool _passwordVisible = true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF40C800),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/');
          },
          icon: Icon(Icons.clear_outlined),
        ),
        backgroundColor: Color(0xFF40C800),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                topText(),
                emailField(),
                SizedBox(height: 20.0,),
                passwordField(),
                SizedBox(height: 20.0,),
                forgetPassword(),
                SizedBox(height: 30.0,),
                loginButton(),
                SizedBox(height: 20.0,),
                googleLoginButton(),
                SizedBox(height: 20.0,),
                signUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topText() {
    return Column(
      children: [
        Text('GroupBuy',
          style: GoogleFonts.ebGaramond(
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 48),
          ),
        ),
        SizedBox(height: 10,),
        Text('Đăng nhập',
          style: GoogleFonts.inter(
            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 24),
          ),
        ),
        SizedBox(height: 10),
        Text('Để có trải nghiệm mua hàng tốt hơn',
          style: GoogleFonts.inter(
            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  Widget emailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54.0),
      child: Container(

        child: TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(Icons.email_outlined),
            hintText: "Email",
          ),
          validator: validateLoginEmail,
          onChanged: (value) {
            setState(() {
              _email = value.trim();
            });
          },
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 54),
      child: TextFormField(
          controller: passwordController,
          obscureText: _passwordVisible,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none
            ),
            hintText: "Mật khẩu",
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          validator: validateLoginPassword,
          onChanged: (value) {
            setState(() {
              _password = value.trim();
            });
          },
        ),
    );
  }

  Widget forgetPassword() {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 54.0),
          child: Text(
            'Quên mật khẩu?',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () async {
        print(formKey.currentState);
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          try {
            await Auth().signInWithEmailAndPassword(
              email: _email,
              password: _password,
            );
            Navigator.of(context).pushNamed('/');
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20.0),
                content: Text('Tài khoản không tồn tại!'),
              ));
            }
            if (e.code == 'wrong-password') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20.0),
                content: Text('Sai mật khẩu!'),
              ));
            }
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 54.0),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF025B05),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(child:
          Text('Đăng nhập',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget googleLoginButton() {
    return IconButton(
      onPressed: () async {
        await Auth().signInWithGoogle();
        Navigator.of(context).pushNamed('/');
      },
      icon: Image.asset('assets/googleIcon.png'),
      iconSize: 50.0,
    );
  }

  Widget signUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Bạn chưa có tài khoản? ',
          style: GoogleFonts.inter(
            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignUpPage.routeName);
          },
          child: Text('Hãy đăng ký',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Color(0xFF025B05), fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}