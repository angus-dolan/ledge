import 'package:flutter/material.dart';

class AppTextSmallMedium extends StatelessWidget {
  double size;
  final String text;
  final Color color;

  AppTextSmallMedium({
    Key? key,
    required this.text,
    required this.color,
    this.size = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w500),
    );
  }
}
