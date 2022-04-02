import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:ledge/misc/utils.dart';
import 'package:ledge/widgets/AppBar.dart';
import 'package:ledge/widgets/text/AppHeadingH4.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextLargeRegular.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: LedgeAppBar(''),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 120),
                AppHeadingH4(
                  text: 'Forgot Password?',
                  color: AppColors.gray900,
                ),
                SizedBox(height: 10),
                AppTextLargeRegular(
                  text:
                      'Enter your email below to receive a password reset link.',
                  color: AppColors.gray500,
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  cursorColor: AppColors.primaryBase,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                  style: new TextStyle(
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: AppColors.gray100,
                    filled: true,
                    labelText: 'Email',
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(16.0),
                      ),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(14.0),
                      ),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(14.0),
                      ),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.0),
                    ),
                  ),
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
                    onPressed: verifyEmail,
                    child: AppTextLargeBold(
                      text: 'Send Email',
                      color: AppColors.white,
                    )),
              ],
            ),
          ),
        ),
      );

  Future verifyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
