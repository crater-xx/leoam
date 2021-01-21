import 'package:flutter/material.dart';
import 'package:leoam/common/global.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leoam/common/UserModel.dart';
import 'package:leoam/common/LocationManager.dart';
import 'package:better_player/better_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BetterPlayerController _betterPlayerController;

  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4");
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _betterPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CurrentLocationState(),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController,
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
    String addr;
    if (lm.currentGeocode != null) {
      addr = lm.currentGeocode.formatAddress;
      Global.netMgr.sendMsgToGate(addr);
    } else {
      addr = "还在定位中";
    }
    return Text(addr);
  }
}

class CurrentLocationInfoState extends StatelessWidget {
  const CurrentLocationInfoState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationManager lm = context.watch<LocationManager>();
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            width: 300,
            height: 100,
            child: Text(lm.currentLocation.toString()),
          ),
        ),
      ),
    );
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
