import 'package:tmsui/utilities/api.dart';

class UserAPI {
  static const String baseUrl = "http://10.0.2.2:8080/ana-service/api/v1/auth";

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return await APIService.request("$baseUrl/login",
        method: "POST", body: {"username": email, "password": password});
  }

  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    return await APIService.request("$baseUrl/register",
        method: "POST",
        body: {"username": username, "email": email, "password": password});
  }
}
