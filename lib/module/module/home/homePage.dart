import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leoam/common/UserModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginStatus(),
    );
  }
}

class LoginStatus extends StatelessWidget {
  const LoginStatus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel um = context.watch<UserModel>();
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
