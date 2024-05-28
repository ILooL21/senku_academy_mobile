import 'dart:convert';

import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:http/http.dart' as http;

class ExerciseController {
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  static Future<http.Response> getExercises(String id) async {
    var url = Uri.parse('$baseApiURL/question/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> getExercise(String id) async {
    var url = Uri.parse('$baseApiURL/question/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> answerExercise(String id, int option) async {
    var url = Uri.parse('$baseApiURL/question/$id/answer');
    var data = json.encode({'option': option});
    http.Response response = await http.post(
      url,
      headers: headers,
      body: data,
    );
    return response;
  }
}
