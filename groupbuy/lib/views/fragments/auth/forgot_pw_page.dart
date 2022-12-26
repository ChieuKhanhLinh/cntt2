import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuy/validate/validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groupbuy/controllers/handle_auth.dart';
import 'package:groupbuy/views/fragments/auth/sign_in_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  static String routeName = '/forgotPassword';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with CommonValidation  {

  final emailController = TextEditingController();
  late String _email;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF40C800),
      appBar: AppBar(
        backgroundColor: Color(0xFF40C800),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Vui lòng nhập email đã đăng ký của bạn'),
              SizedBox(height: 40.0,),
              emailField(),
              SizedBox(height: 20.0,),
              resetPasswordButton(),
            ],
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
          validator: validateResetEmail,
          onChanged: (value) {
            setState(() {
              _email = value.trim();
            });
          },
        ),
      ),
    );
  }

  Widget resetPasswordButton() {
    return GestureDetector(
      onTap: () async {
        print(formKey.currentState);
        if (formKey.currentState!.validate()) {
          try {
            await Auth().passwordReset(email: _email);
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('Liên kết đặt lại mật khẩu đã được gửi đến email của bạn.'),
                  );
                },
            );
            Navigator.pushNamed(context, SignInPage.routeName);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20.0),
                content: Text('Tài khoản không tồn tại!'),
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
          Text('Đặt lại mật khẩu',
            style: GoogleFonts.inter(
              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          ),
        ),
      ),
    );
  }

}
