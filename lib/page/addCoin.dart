import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ledge/main_page.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/misc/utils.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/services/coins_api.dart';
import 'package:ledge/services/database.dart';
import 'package:ledge/widgets/AppBar.dart';
import 'package:ledge/widgets/CoinAvatar.dart';
import 'package:ledge/widgets/SearchWidget.dart';
import 'package:flutter/material.dart';
import 'package:ledge/widgets/text/AppTextMediumBold.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';

final authUser = FirebaseAuth.instance.currentUser!;
final database = DatabaseService(uid: authUser.uid);

class AddCoin extends StatefulWidget {
  @override
  AddCoinPageState createState() => AddCoinPageState();
}

class AddCoinPageState extends State<AddCoin> {
  List<Coin> coins = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final coins = await CoinsApi.searchCoins(query);

    setState(() => this.coins = coins);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: LedgeAppBar('Add Asset'),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: coins.length,
                itemBuilder: (context, index) {
                  final coin = coins[index];

                  return buildCoin(coin);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Ticker or Asset Name',
        onChanged: searchCoin,
      );

  Future searchCoin(String query) async => debounce(() async {
        final coins = await CoinsApi.searchCoins(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.coins = coins;
        });
      });

  Widget buildCoin(Coin coin) => ListTile(
        onTap: () => addCoin(coin, context),
        leading: CoinAvatar(img: coin.img),
        title: AppTextMediumBold(
          text: coin.name,
          color: AppColors.gray900,
        ),
        subtitle: AppTextSmallMedium(
          text: coin.symbol.toUpperCase(),
          color: AppColors.gray500,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      );

  Future addCoin(coin, context) async {
    bool result = await database.addCoin(coin.id);

    if (result) Utils.showSnackBar('${coin.name + ' Added 💪'}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void searchCoins(String query) {
    final suggestions = coins.where((book) {
      final bookTitle = book.name.toLowerCase();
      final input = query.toLowerCase();

      return bookTitle.contains(input);
    }).toList();

    setState(() => coins = suggestions);
  }
}
