import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:http/http.dart' as http;

class LessonController {
  static Future<http.Response> getLessons() async {
    var url = Uri.parse('$baseApiURL/lesson');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> getLesson(String id) async {
    var url = Uri.parse('$baseApiURL/lesson/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }
}
