import 'package:flutter/material.dart';
import 'package:leoam/common/global.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leoam/common/UserModel.dart';
import 'package:leoam/common/LocationManager.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CurrentLocationState(),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
