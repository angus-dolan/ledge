import 'package:flutter/material.dart';

class Assets extends StatefulWidget {
  @override
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Assets')),
        body: Center(
          child: Text('Assets Screen', style: TextStyle(fontSize: 40)),
        ));
  }
}
