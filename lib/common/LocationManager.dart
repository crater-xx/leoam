import 'package:permission_handler/permission_handler.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'dart:io';
import 'package:location/location.dart' as FlutterLocation;

//定位管理类
class LocationManager {
  static LocationManager _instance;

  final FlutterLocation.Location _mylocation = FlutterLocation.Location();

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

  Future<FlutterLocation.LocationData> getLocation() async {
    FlutterLocation.LocationData ld = await _mylocation.getLocation();
    return ld;
  }

  Future<String> getAddressByLocation(double lat, double lng, double ra) async {
    ReGeocode rg =
        await AmapSearch.instance.searchReGeocode(LatLng(lat, lng), radius: ra);
    String addres = rg.toString();
    return addres;
  }
} //class end
