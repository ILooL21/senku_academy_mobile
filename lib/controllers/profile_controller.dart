import 'dart:convert';

import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:senku_academy_mobile/controllers/token_controller.dart';
import 'package:http/http.dart' as http;

class ProfileController {
  static Future<http.Response> updateProfile(String email, String username,
      String oldPassword, String newPassword) async {
    String? token = await TokenController.getToken();
    var tokenMap = json.decode(token!);
    token = tokenMap['token'];
    Map data = {
      'email': email,
      'username': username,
      'oldpassword': oldPassword,
      'newpassword': newPassword,
    };
    var body = json.encode(data);
    var url = Uri.parse('$baseApiURL/update');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    //set token
    if (response.statusCode == 200) {
      var user = json.decode(response.body)['user'];

      var tokenMap = {
        'token': token,
        'user': user,
      };

      await TokenController.setToken(tokenMap);
    }
    return response;
  }
}
