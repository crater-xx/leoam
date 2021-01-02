import 'package:permission_handler/permission_handler.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'dart:io';
import 'package:location/location.dart' as FlutterLocation;
import 'package:logger/logger.dart';

//定位管理类
class LocationManager {
  static LocationManager _instance;

  final FlutterLocation.Location _mylocation = FlutterLocation.Location();
  simpleGeocode _crrentGeocode; //当前aoi
  final List<simpleGeocode> _allAoi = List<simpleGeocode>(); //
  final Logger _logger = Logger();

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
  void addAoi(ReGeocode geocode) {
    if (geocode.aoiList.length > 0 &&
        (_crrentGeocode == null ||
            _crrentGeocode.id != geocode.aoiList[0].id)) {
      _crrentGeocode = simpleGeocode(geocode);
      _allAoi.add(_crrentGeocode);
      _logger.d('new Geocode :' + _crrentGeocode.toString());
    }
  }

  simpleGeocode get currentGeocode => _crrentGeocode;
} //class end

//simpleGeocode
class simpleGeocode extends Aoi {
  DateTime _dt;
  String provinceName;
  String cityName;
  String districtName;
  String township;
  String building;
  String country;
  String formatAddress;
  simpleGeocode(ReGeocode geocode)
      : super(
            adcode: geocode.aoiList[0].adcode,
            area: geocode.aoiList[0].area,
            id: geocode.aoiList[0].id,
            name: geocode.aoiList[0].name,
            centerPoint: geocode.aoiList[0].centerPoint) {
    _dt = new DateTime.now();
    provinceName = geocode.provinceName;
    cityName = geocode.cityName;
    districtName = geocode.districtName;
    township = geocode.township;
    country = geocode.country;
    building = geocode.building;
    formatAddress = geocode.formatAddress;
  }
  @override
  String toString() {
    return 'id: $id , address: $formatAddress ,datetime:' + _dt.toString();
  }
}
