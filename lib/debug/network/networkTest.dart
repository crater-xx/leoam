import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoam/common/global.dart';

/// This is the screen that you'll see when the app starts
class networkTest extends StatefulWidget {
  networkTest({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _networkTestState createState() => _networkTestState();
}

class _networkTestState extends State<networkTest> {
  void initState() {
    super.initState();
    Global.netMgr.conntectGate("ws:202.11.11.22:80");
  }

  void dispose() {
    Global.netMgr.disconnectGate();
    super.dispose();
  }

  TextEditingController _msgController = new TextEditingController();
  final Logger _logger = Logger();
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
            child: Column(
      children: <Widget>[
        Text("net worker test"),
        TextField(
          controller: _msgController,
          onSubmitted: (String value) async {
            _logger.d(value);
          },
        )
      ],
    )));
  }
}
