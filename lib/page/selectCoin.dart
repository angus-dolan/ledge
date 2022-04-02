import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/page/addCoin.dart';
import 'package:ledge/page/buyCoin.dart';
import 'package:ledge/page/sellCoin.dart';
import 'package:ledge/services/database.dart';
import 'package:ledge/widgets/AppBar.dart';
import 'package:ledge/widgets/CoinAvatar.dart';
import 'package:ledge/widgets/text/AppTextMediumBold.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';

final authUser = FirebaseAuth.instance.currentUser!;
final database = DatabaseService(uid: authUser.uid);

class SelectCoin extends StatelessWidget {
  final String action;

  const SelectCoin({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: LedgeAppBar(action),
      body: Container(
          child: FutureBuilder<List<Coin>>(
        future: database.getLedger(),
        builder: (context, snapshot) {
          final ledger = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return buildLedger(ledger!);
              }
          }
        },
      )));

  Widget buildLedger(List<Coin> coins) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: coins.length,
        itemBuilder: (context, index) {
          final coin = coins[index];

          return ListTile(
            onTap: () => selectCoin(context, coin),
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
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      );

  selectCoin(context, coin) {
    if (action == 'Buy') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => BuyCoin(coin: coin)));
    } else if (action == 'Sell') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SellCoin(coin: coin)));
    }
  }
}
