import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/validate/validation.dart';
import 'package:groupbuy/controllers/handle_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuy/views/fragments/auth/sign_in_page.dart';
import 'package:groupbuy/views/fragments/auth/sign_up_page.dart';
import 'package:groupbuy/controllers/handle_user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String routeName = '/signUpPage';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with CommonValidation {

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late String _fullname;
  late String _email;
  late String _phone;
  late String _password;
  late String _confirmPassword;
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

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
                fullNameField(),
                SizedBox(height: 20.0,),
                emailField(),
                SizedBox(height: 20.0,),
                phoneField(),
                SizedBox(height: 20.0,),
                passwordField(),
                SizedBox(height: 20.0,),
                confirmPasswordField(),
                SizedBox(height: 30.0,),
                signUpButton(),
                SizedBox(height: 20.0,),
                signInText(),
                SizedBox(height: 20.0,),
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
        Text('Đăng ký',
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

  Widget fullNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54.0),
      child: Container(
        child: TextFormField(
          controller: fullNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(Icons.person_outline),
            hintText: "Họ và tên",
          ),
          validator: validateSignUpName,
          onChanged: (value) {
            setState(() {
              _fullname = value.trim();
            });
          },
        ),
      ),
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

  Widget phoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54.0),
      child: Container(
        child: TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(Icons.phone_android_outlined),
            hintText: "Số điện thoại",
          ),
          validator: validateSignUpPhone,
          onChanged: (value) {
            setState(() {
              _phone = value.trim();
            });
          },
        ),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54.0),
      child: Container(
        child: TextFormField(
          controller: passwordController,
          obscureText: _passwordVisible,
          decoration: InputDecoration(
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
          validator: validateSignUpPassword,
          onChanged: (value) {
            setState(() {
              _password = value.trim();
            });
          },
        ),
      ),
    );
  }

  Widget confirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54.0),
      child: Container(
        child: TextFormField(
          controller: confirmPasswordController,
          obscureText: _confirmPasswordVisible,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none
            ),
            hintText: "Nhập lại mật khẩu",
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
            ),
          ),
          validator: (input) {
            if (input!.isEmpty) {
              return 'Bạn chưa xác nhận mật khẩu của mình.';
            }
            if (_confirmPassword != _password) {
              return 'Mật khẩu nhập lại không chính xác.';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _confirmPassword = value.trim();
            });
          },
        ),
      ),
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () async {
        try {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            await Auth().createUserWithEmailAndPassword(
              email: _email,
              password: _password,
            );
            HandleUser().userInfo(
              username: _fullname,
              phone: _phone,
            );
            await Auth().signOut();
            Navigator.pushNamed(context, SignInPage.routeName);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              padding: EdgeInsets.all(20),
              content: Text("Email xin lỗi đã tồn tại"),
            ));
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
          Text('Đăng ký',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget signInText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Bạn đã có tài khoản? ',
          style: GoogleFonts.inter(
            textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignInPage.routeName);
          },
          child: Text('Hãy đăng nhập',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Color(0xFF025B05), fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

}
