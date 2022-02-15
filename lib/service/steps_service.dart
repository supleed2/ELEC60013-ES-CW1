import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class StepsService {
  Future<int> getStepsToday(String deviceId, String sessionToken) async {
    final response = await http.get(
      Uri.parse(Endpoints.getStepsToday),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': sessionToken,
        'Device-ID': deviceId,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['cumulative_steps_today'];
    } else {
      return 0;
    }
  }

  Future<List<int>> getStepsLastFiveDays(String deviceId, String sessionToken) async {
    final response = await http.get(
      Uri.parse(Endpoints.getStepsLastFiveDays),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': sessionToken,
        'Device-ID': deviceId,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['daily_steps'];
      List<int> steps = [];
      for (final l in list){
        steps.add(l);
      }
      return steps;
    } else {
      return [];
    }
  }
}