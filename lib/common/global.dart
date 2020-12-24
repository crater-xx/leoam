import 'dart:async';
import 'UserModel.dart';

class Global {
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static UserModel profile = UserModel();
  //1.微信登录
  static String _wexintoken;
  //2.钉钉登录
  //初始化全局信息，会在APP启动时执行

  static Future init() async {
    //1.读取本地微信登录状态
    _wexintoken = 'null';
  }
}
