import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:leoam/common/TTSUtil.dart';

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
  final TTSUtil _tts = new TTSUtil();
  List<Map<String, dynamic>> _allSms = new List<Map<String, dynamic>>();
  @override
  void initState() {
    super.initState();
    evnChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _requestPermission();
    _init();
    _tts.initTTS();
  }

  void _init() async {
    List<String> all = await _getAllSms();
    all.forEach((smsContxt) {
      Map<String, dynamic> sms = json.decode(smsContxt);
      _allSms.add(sms);
    });
    if (_allSms.length > 0) {
      setState(() {});
    }
  }

  void _onEvent(Object event) {
    print('onevent');
  }

  void _onError(Object error) {
    print('onerror');
  }

  void _requestPermission() async {
    await [Permission.sms].request();
    if (await Permission.sms.isDenied) {
      print("sms isdenied");
    }
    if (await Permission.sms.isGranted) {
      print("sms agree");
    }
  }

  Future<List<dynamic>> _getAllSms() async {
    List<dynamic> all = await platform.invokeMethod('getAllSms');
    return all.cast<String>();
  }

  void speekSms(String text) {
    _tts.speak(text);
  }

  Widget _buildListItem(BuildContext context, int index) {
    Map<String, dynamic> sms = _allSms[index];
    return Card(
        elevation: 5,
        color: Colors.blueGrey,
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(
                  sms["addres"],
                  style: TextStyle(fontSize: 28),
                ),
                subtitle: Text(sms["date"])),
            Divider(),
            ListTile(title: Text(sms["body"].toString().substring(0, 30))),
            RaisedButton(
                child: Text("Play"),
                onPressed: () {
                  speekSms(sms["body"]);
                }),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffefefef),
      child: ListView.builder(
          itemCount: _allSms.length, itemBuilder: this._buildListItem),
    );
  }
}
