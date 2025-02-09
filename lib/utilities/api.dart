import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static Future<Map<String, dynamic>> request(
    String endpoint, {
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final Uri uri = Uri.parse("$endpoint");
    headers ??= {"Content-type": "application/json"};

    http.Response response;
    final req = jsonEncode(body);
    try {
      switch (method.toUpperCase()) {
        case "GET":
          response = await http.get(uri, headers: headers);
          break;
        case "POST":
          response =
              await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case "PUT":
          response =
              await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case "PATCH":
          response =
              await http.patch(uri, headers: headers, body: jsonEncode(body));
          break;
        case "DELETE":
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception("Invalid HTTP method: $method");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          return {"message": "No response body"};
        } else {
          return jsonDecode(response.body);
        }
      } else {
        throw Exception("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      throw Exception("Request Failed: $e");
    }
  }
}
