import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/model/userModel.dart';
import 'package:ledge/page/addCoin.dart';
import 'package:ledge/page/buyCoin.dart';
import 'package:ledge/services/coins_api.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/page/viewCoin.dart';
import 'package:ledge/services/database.dart';
import 'package:ledge/widgets/CoinAvatar.dart';
import 'package:ledge/widgets/text/AppTextMediumBold.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';

var priceFormat = new NumberFormat("#,##0.00", "en_US");

final authUser = FirebaseAuth.instance.currentUser!;
final database = DatabaseService(uid: authUser.uid);

class AssetsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Expanded(
          child: SizedBox(
              height: 200,
              child: Scaffold(
                body: FutureBuilder<List<Coin>>(
                  future: CoinsApi.getCoins(),
                  builder: (context, snapshot) {
                    final coins = snapshot.data;

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshot.hasError) {
                          return Center(child: Text('Some error occurred!'));
                        } else {
                          return buildUser(coins!);
                        }
                    }
                  },
                ),
              ))));

  Widget buildUser(coins) => FutureBuilder<AppUser?>(
        future: database.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;

            // return user == null
            //     ? Center(child: Text('No User'))
            //     : buildCoins(user.ledger, coins!);

            return user!.ledger.length == 0
                ? Center(child: Text('No assets 😢'))
                : buildCoins(user.ledger, coins!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );

  Widget buildCoins(Map<String, dynamic> ledger, List<Coin> coins) =>
      ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: ledger.length,
        itemBuilder: (context, index) {
          // Stored coin id in ledger
          final storedCoin = ledger.keys.elementAt(index);

          // Match stored coin id to coin data
          var counter = 0;
          var targetIndex;
          coins.forEach((item) {
            if (item.id == storedCoin) targetIndex = counter;

            counter++;
          });

          // Get stored coins data
          final coin = coins[targetIndex];

          return Slidable(
              key: const ValueKey(
                  0), // Specify a key if the Slidable is dismissible.

              // Slide right to delete
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  database.deleteCoin(ledger.keys.elementAt(index));
                }),
                children: const [
                  SlidableAction(
                    onPressed: doNothing,
                    backgroundColor: Color(0xffEF4444),
                    foregroundColor: Color(0xffffffff),
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),

              // Slide left for buy/sell
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    onPressed: doNothing,
                    backgroundColor: Color(0x95273C75),
                    foregroundColor: Color(0xffffffff),
                    icon: Icons.add_circle_outline_outlined,
                    label: 'Buy',
                  ),
                  SlidableAction(
                    flex: 2,
                    onPressed: doNothing,
                    backgroundColor: Color(0xff273C75),
                    foregroundColor: Color(0xffffffff),
                    icon: Icons.remove_circle_outline_outlined,
                    label: 'Sell',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 20, right: 20),
                leading: CoinAvatar(img: coin.img),
                title: AppTextMediumBold(
                  text: coin.name,
                  color: AppColors.gray900,
                ),
                subtitle: AppTextSmallMedium(
                  text: coin.symbol.toUpperCase(),
                  color: AppColors.gray500,
                ),
                trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTextMediumBold(
                        text:
                            "£${priceFormat.format(double.parse(coin.currentPrice))}",
                        color: AppColors.gray900,
                      ),
                      SizedBox(height: 6),
                      AppTextSmallMedium(
                        text:
                            "${ledger.values.elementAt(index) + ' ' + coin.symbol.toUpperCase()}",
                        color: AppColors.gray500,
                      )
                    ]),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ViewCoin(coin: coin),
                )),
              ));
        },
      );
}

void doNothing(BuildContext context) {}
