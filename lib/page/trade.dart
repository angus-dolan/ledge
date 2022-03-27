import 'package:flutter/material.dart';

class Trade extends StatefulWidget {
  @override
  _TradeState createState() => _TradeState();
}

class _TradeState extends State<Trade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trade')),
        body: Center(
          child: Text('Trade Screen', style: TextStyle(fontSize: 40)),
        ));
  }
}
