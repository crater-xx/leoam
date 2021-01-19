import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/io.dart';
import 'WebSocketUtility.dart';

class NetManager with ChangeNotifier {
  static NetManager _instance;
  NetManager._internal();

  final Logger _logger = Logger();
  var _msgHandle = Map();
  WebSocketUtility _websocket;

  factory NetManager.getInstance() => _getInstance();
  //connect gate way
  bool conntectGate(String url) {
    _websocket = WebSocketUtility(
        onOpen: gateOpen, onMessage: onGateMessage, onError: onGateError);
    _websocket.startConnect(url);
  }

  //注册消息回调函数
  void setMsgCallBack(String fun, Function callback) {
    _msgHandle[fun] = callback;
  }

  void sendMsgToGate(msg) {
    _websocket.sendMessage(msg);
  }

  void disconnectGate() {
    _websocket.closeSocket();
  }

  void gateOpen(IOWebSocketChannel ws) {
    _logger.d('web socket open');
  }

  void onGateMessage(data) {
    //分离消息 触发回调
    _logger.d(data);
  }

  void onGateError(String error) {
    _logger.d(error);
  }

  static _getInstance() {
    if (_instance == null) {
      _instance = NetManager._internal();
    }
    return _instance;
  }
}
