import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:leoam/debug/sms/smsIndex.dart';
import 'package:provider/provider.dart';
import 'package:leoam/debug/qrcode/qrcode.dart';
import 'package:leoam/debug/tts/ttstest.dart';
import 'package:leoam/debug/sms/smsIndex.dart';
import 'package:leoam/debug/location/locationTest.dart';
import 'package:leoam/module/login/loginPage.dart';
import 'package:leoam/common/global.dart';
import 'package:leoam/module/tabsPage.dart';

void main() => Global.init().then((e) => runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [Locale('en', 'US'), Locale('zh', 'CN')],
    fallbackLocale: Locale('zh', 'CN'),
    path: 'assets/translations')));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Global.locationMgr),
        ChangeNotifierProvider(create: (_) => Global.profile)
      ],
      child: MaterialApp(
        title: 'Leo-AM',
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: <String, WidgetBuilder>{
          '/debug/qrcode': (BuildContext context) =>
              MainScreen(title: 'QrCode'),
          '/debug/tts': (BuildContext context) => TTSTest(title: 'ttsTest'),
          '/debug/sms': (BuildContext context) => smsIndex(title: 'smsindex'),
          '/debug/location': (BuildContext context) =>
              locationTest(title: 'location'),
          '/login': (BuildContext content) => LoginPage(title: 'login'),
        },
        initialRoute: "/",
        home: TabsPage(title: tr("MyHomePage_title")),
      ),
    );
  }
}
