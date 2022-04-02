import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/widgets/text/AppHeadingH6.dart';

class LedgeAppBar extends StatelessWidget with PreferredSizeWidget {
  final String _title;

  @override
  final Size preferredSize;

  LedgeAppBar(this._title, {Key? key})
      : preferredSize = Size.fromHeight(80),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
          padding: EdgeInsets.only(top: 18),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: AppColors.gray900, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          )),
      title: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 0),
          child: AppHeadingH6(text: _title, color: AppColors.gray900)),
      elevation: 0,
      titleSpacing: 100,
      centerTitle: true,
      backgroundColor: AppColors.white,
    );
  }
}
