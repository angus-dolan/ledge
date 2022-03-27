import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';
import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ledge',
      theme: ThemeData(
          fontFamily: 'Inter',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: AppColors.white),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
