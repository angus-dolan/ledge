import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ledge/main_page.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/model/coinModel.dart';
import 'package:ledge/services/database.dart';
import 'package:ledge/widgets/AppBar.dart';
import 'package:ledge/widgets/CoinAvatar.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextLargeSemibold.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';

final authUser = FirebaseAuth.instance.currentUser!;
final database = DatabaseService(uid: authUser.uid);

class SellCoin extends StatefulWidget {
  final Coin coin;

  const SellCoin({
    Key? key,
    required this.coin,
  }) : super(key: key);

  @override
  _SellCoinState createState() => new _SellCoinState();
}

class _SellCoinState extends State<SellCoin> {
  final formKey = GlobalKey<FormState>();
  final inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: LedgeAppBar("${'Sell ' + widget.coin.name}"),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, top: 17),
                width: double.maxFinite,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(
                    color: AppColors.gray200, // red as border color
                  ),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CoinAvatar(img: widget.coin.img),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, top: 2),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextLargeSemibold(
                                    text: widget.coin.name,
                                    color: AppColors.gray900),
                                SizedBox(height: 4),
                                AppTextSmallMedium(
                                    text: widget.coin.symbol.toUpperCase(),
                                    color: AppColors.gray500),
                              ]))
                    ]),
              ),
              SizedBox(height: 40),
              Form(
                  key: formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: inputController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16), // <-- Radius
                          ),
                          primary: AppColors.gray900,
                          minimumSize: Size.fromHeight(56),
                        ),
                        onPressed: submit,
                        child: AppTextLargeBold(
                          text: 'Confirm',
                          color: AppColors.white,
                        )),
                  ]))
            ],
          ),
        ),
      );

  submit() {
    database.sellCoin(
        widget.coin.id, double.parse(inputController.text.trim()));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => MainPage()));
  }
}
