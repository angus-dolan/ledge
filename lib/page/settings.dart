import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ledge/misc/colors.dart';
import 'package:ledge/model/userModel.dart';
import 'package:ledge/services/database.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ledge/widgets/text/AppHeadingH6.dart';
import 'package:ledge/widgets/text/AppTextLargeBold.dart';
import 'package:ledge/widgets/text/AppTextMediumBold.dart';
import 'package:ledge/widgets/text/AppTextSmallMedium.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

final authUser = FirebaseAuth.instance.currentUser!;
final database = DatabaseService(uid: authUser.uid);

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 0),
              child: AppHeadingH6(text: 'Settings', color: AppColors.gray900)),
          elevation: 0,
          titleSpacing: 100,
          centerTitle: true,
          backgroundColor: AppColors.white,
        ),
        body: buildSingleUser());
  }
}

Widget buildSingleUser() => FutureBuilder<AppUser?>(
      future: database.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null
              ? Center(child: Text('No User'))
              : buildUser(user);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

Widget buildUser(AppUser user) => Container(
    padding: EdgeInsets.only(left: 20, right: 20),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 40),
          AppTextLargeBold(
            text: 'Personal Information',
            color: AppColors.gray900,
          ),
          const SizedBox(height: 20),
          Container(
              padding: EdgeInsets.only(top: 10),
              width: double.maxFinite,
              height: 140,
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
                              text: 'Name',
                              color: AppColors.gray900,
                            ),
                            trailing: AppTextSmallMedium(
                              text: user.name,
                              color: AppColors.gray500,
                            )),
                        ListTile(
                            onTap: () {},
                            title: AppTextMediumBold(
                              text: 'Email',
                              color: AppColors.gray900,
                            ),
                            trailing: AppTextSmallMedium(
                              text: user.email,
                              color: AppColors.gray500,
                            )),
                      ]),
                    );
                  })),
          const SizedBox(height: 40),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // <-- Radius
                ),
                primary: AppColors.errorDark,
                minimumSize: Size.fromHeight(56),
              ),
              onPressed: () {
                database.signOut();
              },
              child: AppTextLargeBold(
                text: 'Sign Out',
                color: AppColors.white,
              )),
        ]));
