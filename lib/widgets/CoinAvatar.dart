import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ledge/misc/colors.dart';

class CoinAvatar extends StatelessWidget {
  final String img;

  const CoinAvatar({
    Key? key,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFAvatar(
        backgroundColor: AppColors.gray200,
        shape: GFAvatarShape.standard,
        radius: 22,
        child: GFAvatar(
          radius: 21,
          shape: GFAvatarShape.standard,
          backgroundColor: AppColors.white,
          child: GFAvatar(
            radius: 14,
            shape: GFAvatarShape.standard,
            backgroundColor: AppColors.white,
            backgroundImage: NetworkImage(img),
          ),
        ));
  }
}
