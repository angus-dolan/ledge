import 'package:flutter/material.dart';

class AppTextLargeSemibold extends StatelessWidget {
  double size;
  final String text;
  final Color color;

  AppTextLargeSemibold({
    Key? key,
    required this.text,
    required this.color,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w600),
    );
  }
}
