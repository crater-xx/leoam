import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// This is the screen that you'll see when the app starts
class smsIndex extends StatefulWidget {
  smsIndex({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _smsIndexState createState() => _smsIndexState();
}

class _smsIndexState extends State<smsIndex> {
  static const platform = const MethodChannel('com.shouguan.leoam/sms');
  static const EventChannel evnChannel =
      const EventChannel('com.shouguan.leoax/onNewSMS');
  List<String> _allSms;
  @override
  void initState() {
    super.initState();
    evnChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _init();
  }

  void _init() async {
    _allSms = await _getAllSms();
  }

  void _onEvent(Object event) {
    print('onevent');
  }

  void _onError(Object error) {
    print('onerror');
  }

  Future<List<String>> _getAllSms() async {
    List<String> all = await platform.invokeMethod('getAllSms');
    return all;
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Card(
        elevation: 5,
        color: Colors.white30,
        child: Text("item" + index.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffefefef),
      child: ListView.builder(itemCount: 10, itemBuilder: this._buildListItem),
    );
  }
}
