import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';

/// This is the screen that you'll see when the app starts
class location extends StatefulWidget {
  location({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _locationState createState() => _locationState();
}

class _locationState extends State<location> {
  final _latController = TextEditingController(text: '39.9824');
  final _lngController = TextEditingController(text: '116.3053');
  final _radiusController = TextEditingController(text: '200.0');
  final _keywordController = TextEditingController(text: '杭州');
  String _district = '';

  ReGeocode _reGeocode;

  void initState() {
    _init();
  }

  void _init() async {
    if (Platform.isIOS) {
      await AmapCore.init('dfbff67ce9be68b97f1c198e2c3c9fa1');
    } else if (Platform.isAndroid) {
      await AmapCore.init('d2c9012bb9941114039d9fbd9f869d41');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('逆地理编码（坐标转地址）')),
        body: Column(
          children: <Widget>[
            Text('Deliver features faster'),
            Text('Craft beautiful UIs'),
            Flexible(
              child: TextFormField(
                controller: _latController,
                decoration: InputDecoration(hintText: '输入纬度'),
              ),
            ),
            Flexible(
              child: TextFormField(
                controller: _lngController,
                decoration: InputDecoration(hintText: '输入经度'),
              ),
            ),
            TextFormField(
              controller: _radiusController,
              decoration: InputDecoration(hintText: '输入范围半径'),
            ),
            RaisedButton(
              onPressed: () async {
                final reGeocodeList = await AmapSearch.instance.searchReGeocode(
                  LatLng(
                    double.parse(_latController.text),
                    double.parse(_lngController.text),
                  ),
                  radius: 200.0,
                );
                setState(() {
                  _reGeocode = reGeocodeList;
                });
              },
              child: Text('搜索'),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_reGeocode?.toString() ?? ''),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 0,
            ),
            TextFormField(
              controller: _keywordController,
              decoration: InputDecoration(hintText: '输入地区'),
            ),
            RaisedButton(
              onPressed: () async {
                final district = await AmapSearch.instance
                    .searchDistrict(_keywordController.text);
                _district = await district.toString();
                setState(() {});
              },
              child: Text('搜索'),
            ),
            Expanded(child: SingleChildScrollView(child: Text(_district))),
          ],
        ));
  }
}
