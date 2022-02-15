import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/model/metrics_response.dart';
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class MetricsService {
  Future<MetricsResponse> getMetricsSummary(deviceId) async {
    final response = await http.get(
      Uri.parse(Endpoints.getMetricsSummary),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'deviceid': deviceId,
      },
    );
    return MetricsResponse.fromJson(jsonDecode(response.body));
  }
}