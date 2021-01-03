import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    _weixinName = '';
    _phonenum = '';
    _Logined = false;
  }

  String _weixinName; //微信用户名
  String _phonenum; //电话号码
  bool _Logined; //是否已登录
  String get lastLogin => _weixinName;
  bool get isLogin => _Logined;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'account': _weixinName,
        'tokoen': _phonenum,
        'login': _Logined ? 1 : 0,
        'savetime': DateTime.now().toString(),
        'ver': '1.1'
      };

  void authSuccess(String name, String passwd) {
    _weixinName = name;
    _phonenum = passwd;
    _Logined = true;
    this.saveWeiXinAuth();
    notifyListeners();
  }

  void cleanAccount() {
    if (_Logined) {
      _Logined = false;
      this.saveWeiXinAuth();
      notifyListeners();
    }
  }

  void saveWeiXinAuth() async {
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      File weixin = new File('$dir/weixinauth.json');
      String context = jsonEncode(this.toJson());
      //保存认证信息
      weixin.writeAsStringSync(context);
    } on FileSystemException {
      print("save weixin auth error");
    }
  }

  void LoadWeixinAuth() async {
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      File weixin = new File('$dir/weixinauth.json');
      // 读取点击次数（以字符串）
      String contents = await weixin.readAsString();
      Map<String, dynamic> info = jsonDecode(contents);
      if (info['ver'] == '1.1') {
        _weixinName = info['account'];
        _phonenum = info['token'];
        _Logined = info["login"] == 1;
        notifyListeners();
      }
    } on FileSystemException {
      print("load weixin auth error");
    }
  }

  void timerHandler() {
    if (_Logined) {
      //已经登录了

    }
  }
}
