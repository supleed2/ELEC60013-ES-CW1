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

  Future<List<dynamic>> getStepsLastFiveDays(deviceId) async {
    final response = await http.get(
      Uri.parse(Endpoints.getStepsLastFiveDays),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'deviceid': deviceId,
      },
    );
    print(jsonDecode(response.body)['daily_steps'].runtimeType);
    return jsonDecode(response.body)['daily_steps'];
  }
}