import 'package:senku_academy_mobile/controllers/globals.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  static Future<http.Response> getCategories() async {
    var url = Uri.parse('$baseApiURL/category');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> getCategory(String id) async {
    var url = Uri.parse('$baseApiURL/category/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    return response;
  }
}
