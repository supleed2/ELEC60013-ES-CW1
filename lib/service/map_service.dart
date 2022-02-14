import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/model/latitude_longitude.dart';
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;


class MapService{
  Future<LatitudeLongitude> getLastLocation(deviceId) async {
    final response = await http.get(
      Uri.parse(Endpoints.getLastLocation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'deviceid': deviceId,
      },
    );
    print(response.body);
    return LatitudeLongitude.fromJson(jsonDecode(response.body));

  }
}