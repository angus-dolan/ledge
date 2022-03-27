import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';

import 'page/home.dart';
import 'page/assets.dart';
import 'page/trade.dart';
import 'page/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [Home(), Assets(), Trade(), Settings()];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          unselectedFontSize: 12,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          onTap: onTap,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.gray900,
          unselectedItemColor: AppColors.gray400,
          elevation: 20,
          items: [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: 'Assets', icon: Icon(Icons.analytics_rounded)),
            BottomNavigationBarItem(
                label: 'Trade', icon: Icon(Icons.cached_rounded)),
            BottomNavigationBarItem(
                label: 'Settings', icon: Icon(Icons.settings)),
          ]),
    );
  }
}
