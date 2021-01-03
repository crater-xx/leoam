import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

enum ttsStatus { playing, stopped, paused, free }

class TTSUtil {
  TTSUtil._();
  static TTSUtil _manager;
  factory TTSUtil() {
    if (_manager == null) {
      _manager = TTSUtil._();
    }
    return _manager;
  }
  FlutterTts flutterTts;
  //播放队列
  List<String> _playQueue = List<String>();

  ttsStatus _status = ttsStatus.free;

  ttsStatus get status => _status;

  set language(String l) => flutterTts.setLanguage(l);
  set volume(double n) => flutterTts.setVolume(n);
  set pitch(double n) => flutterTts.setPitch(n);
  set speechRate(double n) => flutterTts.setSpeechRate(n);

  initTTS() {
    flutterTts = FlutterTts();
    if (Platform.isIOS) {
      /// 设置音量
      flutterTts.setVolume(0.8);

      /// 设置语速
      flutterTts.setSpeechRate(0.4);

      /// 音调
      flutterTts.setPitch(1.0);
    } else {
      /// 设置音量
      flutterTts.setVolume(0.8);

      /// 设置语速
      flutterTts.setSpeechRate(0.8);

      /// 音调
      flutterTts.setPitch(1.1);
    }

    /// 设置语言
    flutterTts.setLanguage("zh-CN");

    flutterTts.setCancelHandler(() {
      _status = ttsStatus.free;
    });
    flutterTts.setCompletionHandler(() {
      _status = ttsStatus.free;
    });
    flutterTts.setErrorHandler((message) {
      _status = ttsStatus.free;
    });
    flutterTts.setPauseHandler(() {
      _status = ttsStatus.stopped;
    });
    flutterTts.setContinueHandler(() {
      _status = ttsStatus.playing;
    });
  }

  //更新播放队列
  void update() {
    if (_status == ttsStatus.free) {
      if (_playQueue.length > 0) {
        String text = _playQueue.removeAt(0);
        speak(text);
      }
    }
  }

  void addPlayQueue(String text) {
    _playQueue.add(text);
  }

  Future speak(String text) async {
    // text = "你好，我的名字是李磊，你是不是韩梅梅？";
    if (text != null) {
      if (text.isNotEmpty) {
        var result = await flutterTts.speak(text);
        if (result == 1) {
          _status = ttsStatus.playing;
        }
      }
    }
  }

  /// 暂停
  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) {
      _status = ttsStatus.paused;
    }
  }

  /// 结束
  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      _status = ttsStatus.stopped;
    }
  }
}
