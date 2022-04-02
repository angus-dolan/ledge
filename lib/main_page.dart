import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/page/selectCoin.dart';
import 'package:ledge/widgets/text/AppHeadingH6.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';

import 'page/home.dart';
import 'page/trade.dart';
import 'page/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

// class _MainPageState extends State<MainPage> {
//   List pages = [Home(), Container(), Settings()];
//   int currentIndex = 0;
//   void onTap(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: pages[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//           unselectedFontSize: 12,
//           selectedFontSize: 12,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: AppColors.white,
//           onTap: onTap,
//           currentIndex: currentIndex,
//           selectedItemColor: AppColors.gray900,
//           unselectedItemColor: AppColors.gray400,
//           elevation: 20,
//           items: [
//             BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
//             BottomNavigationBarItem(
//                 label: 'Trade', icon: Icon(Icons.cached_rounded)),
//             BottomNavigationBarItem(
//                 label: 'Settings', icon: Icon(Icons.settings)),
//           ]),
//     );
//   }
// }

class _MainPageState extends State<MainPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      Home(),
      Container(),
      Settings(),
    ];
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
      const BottomNavigationBarItem(
          icon: Icon(Icons.cached_rounded), label: 'Trade'),
      const BottomNavigationBarItem(
          label: 'Settings', icon: Icon(Icons.settings)),
    ];
    assert(_kTabPages.length == _kBottmonNavBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      selectedItemColor: AppColors.gray900,
      unselectedItemColor: AppColors.gray400,
      backgroundColor: AppColors.white,
      elevation: 20,
      unselectedFontSize: 12,
      selectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (index == 1) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) => Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  AppHeadingH6(text: 'Trade', color: AppColors.gray900),
                  SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // <-- Radius
                        ),
                        primary: AppColors.gray100,
                        minimumSize: Size.fromHeight(56),
                      ),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SelectCoin(action: 'Buy'),
                          )),
                      child: Row(children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.add_circle_outline_outlined,
                                color: AppColors.primaryBase)),
                        AppTextLargeBold(
                          text: 'Buy',
                          color: AppColors.gray900,
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: AppColors.gray500),
                      ])),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // <-- Radius
                        ),
                        primary: AppColors.gray100,
                        minimumSize: Size.fromHeight(56),
                      ),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SelectCoin(action: 'Sell'),
                          )),
                      child: Row(children: [
                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.remove_circle_outline_outlined,
                                color: AppColors.primaryBase)),
                        AppTextLargeBold(
                          text: 'Sell',
                          color: AppColors.gray900,
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: AppColors.gray500),
                      ])),
                  SizedBox(height: 50),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16), // <-- Radius
                          ),
                          primary: AppColors.gray900,
                          minimumSize: Size.fromHeight(56),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: AppTextLargeBold(
                          text: 'Close',
                          color: AppColors.white,
                        )),
                  ),
                ],
              ),
            ),
          );
          return;
        }

        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
