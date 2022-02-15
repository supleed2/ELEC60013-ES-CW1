import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/model/metrics_response.dart';
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class MetricsService {
  Future<MetricsResponse> getMetricsSummary(String deviceId, String sessionToken) async {
    final response = await http.get(
      Uri.parse(Endpoints.getMetricsSummary),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': sessionToken,
        'Device-ID': deviceId,
      },
    );
    if (response.statusCode == 200) {
      return MetricsResponse.fromJson(jsonDecode(response.body));
    } else {
      return MetricsResponse(0, 0, 0, 0, 0, 0, 0, 0, 0);
    }
  }
}