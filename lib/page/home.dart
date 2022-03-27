import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';

import 'package:ledge/widgets/AppTextSmallMedium.dart';
import 'package:ledge/widgets/AppTextLargeBold.dart';
import 'package:ledge/widgets/AppTextMediumMedium.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 70, left: 20),
          child: Row(
            children: [
              //
              // User
              //
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                AppTextSmallMedium(
                    text: "Welcome Back!", color: AppColors.gray500),
                Padding(padding: const EdgeInsets.all(5)),
                AppTextLargeBold(text: "Angus Dolan", color: AppColors.gray900),
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
                margin: const EdgeInsets.only(right: 20),
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
      ],
    ));
  }
}
