import 'package:flutter/material.dart';
import 'package:leoam/common/global.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leoam/common/UserModel.dart';
import 'package:leoam/common/LocationManager.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CurrentLocationState(),
      ),
      body: const Center(
        child: Text(
          'This is the next page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class CurrentLocationState extends StatelessWidget {
  const CurrentLocationState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationManager lm = context.watch<LocationManager>();
    String addr =
        lm.currentGeocode == null ? '未知' : lm.currentGeocode.formatAddress;
    Global.tts.addPlayQueue(addr);
    return Text(addr);
  }
}

class LoginStatus extends StatelessWidget {
  const LoginStatus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel um = context.watch<UserModel>();
    LocationManager lm = context.watch<LocationManager>();

    if (um.isLogin) {
      return RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () => um.cleanAccount(),
          textColor: Colors.white,
          child: Text(tr('homePage.logout')));
    } else {
      return RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pushNamed(context, '/login'),
          textColor: Colors.white,
          child: Text(tr('homePage.goLogin')));
    }
  }
}
