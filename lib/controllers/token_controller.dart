import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenController {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> setToken(Map<String, dynamic> json) async {
    var bearertoken = json['token'];
    var user = json['user'];

    var token = jsonEncode({
      'token': bearertoken,
      'user': user,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
