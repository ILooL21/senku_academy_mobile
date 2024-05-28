import 'dart:convert';

import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:http/http.dart' as http;

class RegistrationController {
  static Future<http.Response> register(
      String username, String email, String password) async {
    Map data = {
      'username': username,
      'email': email,
      'password': password,
    };

    var body = json.encode(data);
    var url = Uri.parse('$baseApiURL/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }
}
