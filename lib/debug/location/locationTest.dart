import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:leoam/common/LocationManager.dart';

/// This is the screen that you'll see when the app starts
class locationTest extends StatefulWidget {
  locationTest({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _locationState createState() => _locationState();
}

class _locationState extends State<locationTest> {
  final _latController = TextEditingController(text: '39.9824');
  final _lngController = TextEditingController(text: '116.3053');
  final _radiusController = TextEditingController(text: '200.0');
  final _keywordController = TextEditingController(text: '杭州');
  String _district = '';
  String _reGeocode;
  final LocationManager _locationMgr = LocationManager.getInstance();

  void initState() {
    _locationMgr.init();
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
                final reGeocodeList = await _locationMgr.getAddressByLocation(
                    lat: 20.0, lng: 10.0, ra: 20.0);
                setState(() {
                  _reGeocode = reGeocodeList;
                });
              },
              child: Text('搜索'),
            ),
            RaisedButton(
              child: Text('获取单次定位'),
              onPressed: () async {
                final location = await AmapLocation.instance
                    .fetchLocation(needAddress: true);
                setState(() {
                  _latController.text = location.latLng.latitude.toString();
                  _lngController.text = location.latLng.longitude.toString();
                });
              },
            ),
            RaisedButton(
              child: Text('Flutter定位'),
              onPressed: () async {
                final FlutterLocation.LocationData location =
                    await _mylocation.getLocation();
                setState(() {
                  _latController.text = location.latitude.toString();
                  _lngController.text = location.longitude.toString();
                });
              },
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
