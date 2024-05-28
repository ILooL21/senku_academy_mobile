import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:http/http.dart' as http;

class ChapterController {
  static Future<http.Response> getChapters(String id) async {
    var url = Uri.parse('$baseApiURL/chapter/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> getChapter(String id) async {
    var url = Uri.parse('$baseApiURL/chapter/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }
}
