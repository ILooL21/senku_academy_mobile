import 'dart:convert';

import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:senku_academy_mobile/controllers/token_controller.dart';
import 'package:http/http.dart' as http;

class LoginController {
  static Future<http.Response> login(String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseApiURL/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    //set token
    if (response.statusCode == 200) {
      var token = json.decode(response.body)['token'];
      var user = json.decode(response.body)['user'];

      var tokenMap = {
        'token': token,
        'user': user,
      };

      await TokenController.setToken(tokenMap);
    }
    return response;
  }

  static Future<http.Response> logout() async {
    var url = Uri.parse('$baseApiURL/logout');
    String? token = await TokenController.getToken();

    //decode dan ambil token
    var tokenMap = json.decode(token!);
    token = tokenMap['token'];

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );
    //remove token
    if (response.statusCode == 200) {
      await TokenController.removeToken();
    }
    return response;
  }
}
