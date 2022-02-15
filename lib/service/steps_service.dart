import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class StepsService {
  Future<int> getStepsToday(deviceId) async {
    final response = await http.get(
      Uri.parse(Endpoints.getStepsToday),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'deviceid': deviceId,
      },
    );
    return jsonDecode(response.body)['cumulative_steps_today'];
  }

  Future<List<int>> getStepsLastFiveDays(deviceId) async {
    final response = await http.get(
      Uri.parse(Endpoints.getStepsLastFiveDays),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'deviceid': deviceId,
      },
    );
    List<dynamic> list = jsonDecode(response.body)['daily_steps'];
    List<int> steps = [];
    for (final l in list){
      steps.add(l);
    }
    return steps;
  }
}