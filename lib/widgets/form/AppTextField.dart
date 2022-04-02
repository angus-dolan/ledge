import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';

class AppTextField extends StatelessWidget {
  var controller;
  var label;
  bool obscureText;

  AppTextField({
    Key? key,
    this.controller,
    this.label,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.primaryBase,
      textInputAction: TextInputAction.next,
      obscureText: obscureText,
      style: new TextStyle(
          height: 1.3,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: AppColors.gray100,
        filled: true,
        labelText: label,
        enabledBorder: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(16.0),
          ),
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(14.0),
          ),
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(14.0),
          ),
          borderSide: const BorderSide(color: Colors.white, width: 0.0),
        ),
      ),
    );
  }
}
