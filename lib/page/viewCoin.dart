import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/model/coinDetailedModel.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/services/coins_api.dart';
import 'package:ledge/widgets/AppBar.dart';
import 'package:ledge/widgets/text/AppHeadingH4.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextLargeRegular.dart';
import 'package:ledge/widgets/text/AppTextMediumBold.dart';
import 'package:ledge/widgets/text/AppTextMediumMedium.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

var priceFormat = new NumberFormat("#,##0.00", "en_US");

class ViewCoin extends StatefulWidget {
  final Coin coin;

  const ViewCoin({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  _ViewCoinState createState() => new _ViewCoinState();
}

class _ViewCoinState extends State<ViewCoin> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: LedgeAppBar(widget.coin.name),
      body: Container(
          child: FutureBuilder<CoinDetailed>(
        future: CoinsApi.getCoinDetailed(widget.coin.id),
        builder: (context, snapshot) {
          final coinData = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return buildView(coinData!);
              }
          }
        },
      )));

  Widget buildView(CoinDetailed coin) => SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                AppTextMediumMedium(
                    text: '${coin.name + ' price'}', color: AppColors.gray500),
                const SizedBox(height: 5),
                AppHeadingH4(
                    text:
                        '£${priceFormat.format(double.parse(coin.currentPrice))}',
                    color: AppColors.gray900),
              ]),
              const SizedBox(height: 40),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  width: double.maxFinite,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                        color: AppColors.gray200, // red as border color
                      )),
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 4),
                          child: Column(children: [
                            ListTile(
                                onTap: () {},
                                title: AppTextMediumBold(
                                  text: 'Rank',
                                  color: AppColors.gray900,
                                ),
                                trailing: AppTextSmallMedium(
                                  text: '${'#' + coin.rank}',
                                  color: AppColors.gray500,
                                )),
                            ListTile(
                                title: AppTextMediumBold(
                                  text: 'Website',
                                  color: AppColors.gray900,
                                ),
                                trailing: Linkify(
                                  text: coin.website.elementAt(0),
                                )),
                            ListTile(
                                onTap: () {},
                                title: AppTextMediumBold(
                                  text: 'Created',
                                  color: AppColors.gray900,
                                ),
                                trailing: AppTextSmallMedium(
                                  text: coin.genesisDate,
                                  color: AppColors.gray500,
                                )),
                          ]),
                        );
                      })),
              const SizedBox(height: 40),
              AppTextLargeBold(
                text: 'About',
                color: AppColors.gray900,
              ),
              const SizedBox(height: 20),
              AppTextLargeRegular(
                text: coin.description,
                color: AppColors.gray500,
              ),
              const SizedBox(height: 60),
            ],
          )));
}
