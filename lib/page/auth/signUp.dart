import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ledge/main.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/misc/utils.dart';
import 'package:ledge/services/database.dart';
import 'package:ledge/widgets/text/AppHeadingH4.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextLargeRegular.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpPage({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 120),
                AppHeadingH4(
                  text: 'Create a Ledge \naccount',
                  color: AppColors.gray900,
                ),
                SizedBox(height: 60),
                //
                // Name
                //
                TextFormField(
                  controller: nameController,
                  cursorColor: AppColors.primaryBase,
                  textInputAction: TextInputAction.next,
                  style: new TextStyle(
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: AppColors.gray100,
                    filled: true,
                    labelText: 'Name',
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
                // Email
                TextFormField(
                  controller: emailController,
                  cursorColor: AppColors.primaryBase,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Please enter a valid email'
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
                //
                // Password
                TextFormField(
                  controller: passwordController,
                  cursorColor: AppColors.primaryBase,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Password must be atleast 6 characters'
                      : null,
                  style: new TextStyle(
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: AppColors.gray100,
                    filled: true,
                    labelText: 'Password',
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
                    onPressed: signUp,
                    child: AppTextLargeBold(
                      text: 'Sign Up',
                      color: AppColors.white,
                    )),
                SizedBox(height: 100),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppColors.gray500, fontSize: 16),
                    text: "Already have an account ?  ",
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Sign In',
                        style: TextStyle(
                            color: AppColors.primaryBase,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    // Create a new user document in database
    final user = FirebaseAuth.instance.currentUser!;
    await DatabaseService(uid: user.uid).createUser(
        user.uid, nameController.text.trim(), emailController.text.trim());

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
