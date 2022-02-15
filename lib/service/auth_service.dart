import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class AuthService{
  Future<List<String>> getUserDevices(String sessionToken) async {
    final response = await http.get(
      Uri.parse(Endpoints.getUserDevices),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': sessionToken,
      },
    );
    if (response.statusCode == 200){
      List<dynamic> list = jsonDecode(response.body)['devices'];
      List<String> res = [];
      for (final l in list) {
        res.add(l.toString());
      }
      return res;
    } else{
      return [];
    }
  }
}