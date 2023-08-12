import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    Uri uri = Uri.parse(url); // Chuyển đổi chuỗi URL thành đối tượng Uri
    http.Response response = await http.get(uri);
    try {
      if (response.statusCode == 200) {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      } else {
        return "Fail";
      }
    } catch (exp) {
      return "Fail";
    }
  }
}
