import 'package:flutter/services.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class smsManager {
  smsManager(){
    _platformVersion = 'Unknown';
  }
  TwilioFlutter twilioFlutter;
  String _platformVersion;


  void getAllSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);
  }
}
