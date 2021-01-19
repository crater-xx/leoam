import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'WebSocketUtility.dart';

class NetManager with ChangeNotifier {
  static NetManager _instance;
  NetManager._internal();

  final Logger _logger = Logger();
  final WebSocketUtility _websocket = WebSocketUtility();

  factory NetManager.getInstance() => _getInstance();
  //connect gate way
  bool conntectGate(String url) {
    _websocket.startConnect(url);
  }

  void disconnectGate() {
    _websocket.closeSocket();
  }

  void gateOpen(){

  }

  void onGateMessage

  static _getInstance() {
    if (_instance == null) {
      _instance = NetManager._internal();
    }
    return _instance;
  }
}
