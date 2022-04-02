import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/model/userModel.dart';
import 'package:ledge/page/addCoin.dart';
import 'package:ledge/page/buyCoin.dart';
import 'package:ledge/page/selectCoin.dart';
import 'package:ledge/page/sellCoin.dart';
import 'package:ledge/services/coins_api.dart';
import 'package:ledge/services/database.dart';

import 'package:ledge/widgets/text/AppHeadingH4.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextMediumMedium.dart';
import 'package:ledge/widgets/text/AppHeadingH6.dart';
import 'package:ledge/widgets/AssetsWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

var priceFormat = new NumberFormat("#,##0.00", "en_US");
var authUser = FirebaseAuth.instance.currentUser!;
var database = DatabaseService(uid: authUser.uid);
var user = database.getUser();

class _HomeState extends State<Home> {
  final controller = StreamController<Future<AppUser?>>();

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 0, right: 0),
        child: Column(
          children: [
            // Top Menu
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  //
                  // User
                  //
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextSmallMedium(
                            text: "Welcome Back!", color: AppColors.gray500),
                        SizedBox(height: 7),
                        buildUserName(),
                      ]),
                  //
                  // Spacer
                  //
                  Expanded(child: Container()),
                  //
                  // Currency
                  //
                  Container(
                    child: Align(
                        alignment: Alignment.center,
                        child: AppTextMediumMedium(
                            text: "GBP", color: AppColors.gray800)),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.gray100,
                    ),
                  )
                ],
              ),
            ),
            // Portfolio Card
            Container(
              margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
              width: double.maxFinite,
              height: 190,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.gray200, // red as border color
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.white),
              child: Column(
                children: [
                  //
                  // Portfolio Balance
                  Container(
                      padding: const EdgeInsets.only(left: 20),
                      width: double.maxFinite,
                      height: 108,
                      child: Row(children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextSmallMedium(
                                  text: "Portfolio Balance",
                                  color: AppColors.gray900),
                              SizedBox(height: 10),
                              buildPortfolioBalanceStream()
                            ])
                      ])),
                  //
                  // Buy, Sell, Convert
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.gray50),
                    width: double.maxFinite,
                    height: 80,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Buy
                          Column(children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.add_circle_outline_outlined),
                              color: AppColors.primaryBase,
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SelectCoin(action: 'Buy'),
                              )),
                              // onPressed: () {},
                            ),
                            AppTextSmallMedium(
                                text: "Buy", color: AppColors.gray900)
                          ]),
                          // Sell
                          Column(children: [
                            IconButton(
                              icon: const Icon(
                                  Icons.remove_circle_outline_outlined),
                              color: AppColors.primaryBase,
                              onPressed: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SelectCoin(action: 'Sell'),
                              )),
                            ),
                            AppTextSmallMedium(
                                text: "Sell", color: AppColors.gray900)
                          ]),
                          // Convert
                          // Column(children: [
                          //   IconButton(
                          //     icon: const Icon(
                          //         Icons.swap_horizontal_circle_outlined),
                          //     color: AppColors.primaryBase,
                          //     onPressed: () {},
                          //   ),
                          //   AppTextSmallMedium(
                          //       text: "Convert", color: AppColors.gray900)
                          // ]),
                        ]),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 10, left: 20, right: 20),
              child: Row(
                children: [
                  //
                  // Assets
                  //
                  Column(children: [
                    SizedBox(height: 40),
                    AppHeadingH6(text: "Assets", color: AppColors.gray900),
                    SizedBox(height: 10),
                  ]),
                  Expanded(child: Container()),
                  Container(
                      margin: const EdgeInsets.only(top: 25),
                      width: 39,
                      child: RawMaterialButton(
                        // onPressed: () => DatabaseService(uid: '').signOut(),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AddCoin(),
                        )),
                        elevation: 0,
                        fillColor: AppColors.primaryBase,
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 16,
                        ),
                        padding: EdgeInsets.all(10.0),
                        shape: CircleBorder(),
                      ))
                ],
              ),
            ),
            AssetsWidget()
          ],
        ),
      ),
    );
  }

  Widget buildUserName() => FutureBuilder<AppUser?>(
        future: database.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;

            return user == null
                ? Center(child: Text('No User'))
                : AppTextLargeBold(text: user.name, color: AppColors.gray900);
          } else {
            return AppTextLargeBold(text: '', color: AppColors.gray900);
          }
        },
      );

  Widget buildPortfolioBalanceStream() => StreamBuilder<Future<AppUser?>>(
        initialData: database.getUser(),
        stream: DatabaseService.getUserStream(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return AppHeadingH4(text: "£0", color: AppColors.gray900);
            default:
              if (snapshot.hasError) {
                return AppHeadingH4(text: "Error", color: AppColors.gray900);
              } else {
                final user = snapshot.data;
                return user == null
                    ? Center(child: Text('No User'))
                    : buildUser(user);
              }
          }
        },
      );

  Widget buildUser(user) => FutureBuilder<AppUser?>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;

            return user == null
                ? Center(child: Text('No User'))
                : buildPortfolioBalanceText(user);
          } else {
            return AppHeadingH4(text: "£0", color: AppColors.gray900);
          }
        },
      );

  Widget buildPortfolioBalanceText(user) => FutureBuilder<List<Coin>>(
      future: CoinsApi.getCoins(),
      builder: (context, snapshot) {
        final coins = snapshot.data;
        double balance = 0;

        if (snapshot.hasData) {
          if (user.ledger.length > 0) {
            user.ledger.forEach((k, amountOwned) {
              var counter = 0;
              var targetIndex;
              coins?.forEach((item) {
                if (item.id == k) targetIndex = counter;

                counter++;
              });

              final coin = coins![targetIndex];
              balance = balance +
                  double.parse(coin.currentPrice) * double.parse(amountOwned);
            });
          }
        }

        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred!'));
        } else {
          return AppHeadingH4(
              text: '£${priceFormat.format(balance)}',
              color: AppColors.gray900);
        }
      });
}
