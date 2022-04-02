import 'package:firebase_auth/firebase_auth.dart';
import 'package:ledge/main.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/page/auth/forgotPassword.dart';
import 'package:ledge/misc/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ledge/widgets/form/AppTextField.dart';
import 'package:ledge/widgets/text/AppHeadingH4.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextLargeRegular.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 120),
        AppHeadingH4(
          text: 'Hi There! 👋',
          color: AppColors.gray900,
        ),
        SizedBox(height: 10),
        AppTextLargeRegular(
          text: 'Welcome back, Sign in to your account',
          color: AppColors.gray500,
        ),
        SizedBox(height: 60),
        AppTextField(
          obscureText: false,
          label: 'Email',
          controller: emailController,
        ),
        SizedBox(height: 20),
        AppTextField(
          obscureText: true,
          label: 'Password',
          controller: passwordController,
        ),
        SizedBox(height: 20),
        GestureDetector(
          child: AppTextLargeBold(
            text: 'Forgot Password?',
            color: AppColors.primaryBase,
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(),
          )),
        ),
        SizedBox(height: 20),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // <-- Radius
              ),
              primary: AppColors.gray900,
              minimumSize: Size.fromHeight(56),
            ),
            onPressed: signIn,
            child: AppTextLargeBold(
              text: 'Sign In',
              color: AppColors.white,
            )),
        SizedBox(height: 100),
        RichText(
          text: TextSpan(
            style: TextStyle(color: AppColors.gray500, fontSize: 16),
            text: "Don't have an account ?  ",
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
                text: 'Sign Up',
                style: TextStyle(
                    color: AppColors.primaryBase,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ]));

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    // Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
