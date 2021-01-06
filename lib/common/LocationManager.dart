import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:location/location.dart' as FlutterLocation;
import 'package:logger/logger.dart';

//定位管理类
class LocationManager with ChangeNotifier {
  static LocationManager _instance;

  final FlutterLocation.Location _mylocation = FlutterLocation.Location();
  simpleGeocode _crrentGeocode; //当前aoi
  FlutterLocation.LocationData _currentLocation;
  final List<simpleGeocode> _allAoi = List<simpleGeocode>(); //
  final Logger _logger = Logger();
  double _testLatitude;
  double _testLongitude;

  LocationManager._internal();

  factory LocationManager.getInstance() => _getInstance();

  static _getInstance() {
    if (_instance == null) {
      _instance = LocationManager._internal();
    }
    return _instance;
  }

  void init() async {
    await _requestPermission();
    if (Platform.isIOS) {
      await AmapCore.init('dfbff67ce9be68b97f1c198e2c3c9fa1');
      AmapLocation.instance.init(iosKey: 'dfbff67ce9be68b97f1c198e2c3c9fa1');
    } else {
      AmapLocation.instance.init();
    }
  }

  void setDebug(double lat, double lng) {
    _testLatitude = lat;
    _testLongitude = lng;
  }

  //请求权限
  void _requestPermission() async {
    await [Permission.location].request();
    if (await Permission.location.isDenied) {
      print("location isdenied");
    }
    if (await Permission.location.isGranted) {
      print("location agree");
    }
  }

  Future<Location> fetchLocation() async {
    final Location l =
        await AmapLocation.instance.fetchLocation(needAddress: false);
    return l;
  }

  Future<FlutterLocation.LocationData> getQuickLocation() async {
    if (_testLongitude != null) {
      _testLongitude -= 0.001;
      return FlutterLocation.LocationData.fromMap({
        'latitude': _testLatitude,
        'longitude': _testLongitude,
        'accuracy': 0,
        'altitude': 0,
        'speed': 1,
        'speed_accuracy': 1,
        'heading': 0,
        'time': 0,
      });
    }
    FlutterLocation.LocationData fld = await _mylocation.getLocation();
    return fld;
  }

  Future<ReGeocode> getAddressByLocation(
      double lat, double lng, double ra) async {
    ReGeocode rg =
        await AmapSearch.instance.searchReGeocode(LatLng(lat, lng), radius: ra);
    return rg;
  }

  Future<String> searchDistrict(String addr) async {
    final District d = await AmapSearch.instance.searchDistrict(addr);
    return d.toString();
  }

  //
  bool addAoi(ReGeocode geocode) {
    if (_crrentGeocode == null ||
        (geocode.aoiList.length > 0 &&
            _crrentGeocode.id != geocode.aoiList[0].id) ||
        geocode.townCode != _crrentGeocode.id) {
      _crrentGeocode = simpleGeocode(geocode);
      _allAoi.add(_crrentGeocode);
      _logger.d('new Geocode :' + _crrentGeocode.toString());
      notifyListeners();
      return true;
    }
    return false;
  }

  //检测位置变化
  void checkLocation(double ra) async {
    _currentLocation = await getQuickLocation();
    ReGeocode rg = await getAddressByLocation(
        _currentLocation.latitude, _currentLocation.longitude, ra);
    addAoi(rg);
  }

  simpleGeocode get currentGeocode => _crrentGeocode;
  FlutterLocation.LocationData get currentLocation => _currentLocation;
} //class end

//simpleGeocode
class simpleGeocode {
  DateTime _dt;
  String provinceName;
  String cityName;
  String districtName;
  String township;
  String building;
  String country;
  String formatAddress;
  String adcode;
  double area;
  String id;
  String name;
  LatLng centerPoint;
  simpleGeocode(ReGeocode geocode) {
    _dt = new DateTime.now();
    provinceName = geocode.provinceName;
    cityName = geocode.cityName;
    districtName = geocode.districtName;
    township = geocode.township;
    country = geocode.country;
    building = geocode.building;
    formatAddress = geocode.formatAddress;
    if (geocode.aoiList.length > 0) {
      id = geocode.aoiList[0].id;
      adcode = geocode.aoiList[0].adcode;
      area = geocode.aoiList[0].area;
      name = geocode.aoiList[0].name;
      centerPoint = geocode.aoiList[0].centerPoint;
    } else {
      id = geocode.townCode;
    }
  }
  @override
  String toString() {
    return 'id: $id , address: $formatAddress ,datetime:' + _dt.toString();
  }
}
