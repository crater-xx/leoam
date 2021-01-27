import 'dart:async';
import 'UserModel.dart';
import 'LocationManager.dart';
import 'TTSUtil.dart';
import 'NetManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static Timer _timer10;
  static Timer _timer1;
  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static UserModel profile = UserModel();
  static TTSUtil tts = TTSUtil();
  static LocationManager locationMgr = LocationManager.getInstance();
  static NetManager netMgr = NetManager.getInstance();
  //1.微信登录
  static String _wexintoken;
  //2.钉钉登录

  static Future init() async {
    SharedPreferences.setMockInitialValues({});
    //1.读取本地微信登录状态
    _wexintoken = 'null';
  }

  //启动定时器
  static void startTimeout() {
    _timer10 = Timer.periodic(Duration(seconds: 10), timer10Seconds);
    _timer1 = Timer.periodic(Duration(seconds: 1), timer1Seconds);
  }

  static void stopTimeout() {
    _timer10.cancel();
    _timer1.cancel();
  }

  static void timer1Seconds(timer) {
    tts.update();
  }

  static void timer10Seconds(timer) {
    // locationMgr.checkLocation(5);
  }
}
