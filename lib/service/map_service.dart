import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/model/latitude_longitude.dart';
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class MapService{
  Future<LatitudeLongitude> getPetLastLocation(deviceId) async {
    final response = await http.get(
      Uri.parse(Endpoints.getLastLocation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'deviceid': deviceId,
      },
    );
    return LatitudeLongitude.fromJson(jsonDecode(response.body));
  }

  Future<Position> getMyLocation() async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location denied');
      }
    }
    return await Geolocator.getCurrentPosition();

  }

}