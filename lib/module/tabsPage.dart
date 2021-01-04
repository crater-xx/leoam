import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leoam/common/UserModel.dart';
import 'package:leoam/module/home/homePage.dart';
import 'package:leoam/module/setting/SettingsPage.dart';
import 'package:leoam/common/global.dart';

class TabsPage extends StatefulWidget {
  TabsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int currentIndex = 0;

  List listTabs = [
    HomePage(),
    SettingsPage(),
    SettingsPage(),
  ];
  @override
  void initState() {
    super.initState();
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    Global.profile.LoadWeixinAuth();
    Global.tts.initTTS();
    Global.locationMgr.init();
    Global.locationMgr.checkLocation(10);
    //  Global.locationMgr.setDebug(31.247368, 121.469203);
    Global.startTimeout();
  }

  void dispose() {
    Global.stopTimeout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.currentIndex,
        iconSize: 30.0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            this.currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('分类'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('设置'),
          ),
        ],
      ),
      body: this.listTabs[this.currentIndex],
    );
  }
}
