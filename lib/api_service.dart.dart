import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testt/model/UserModel.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:58154/api/auth";
  static String? token;


  static Map<String, String> _headers({bool withAuth = false}) {
    final headers = {
      'Accept': 'application/json',
      'Accept-Language': 'ar',
    };
    if (withAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }


  static Future<Map<String, dynamic>> register(Map<String, String> body) async {
    final uri = Uri.parse("$baseUrl/register");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_headers());

    body.forEach((key, value) {
      request.fields[key] = value.trim();
    });

    print(" [REGISTER] URL: $uri");
    print(" Headers: ${request.headers}");
    print(" Fields: ${request.fields}");

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("✅ Status Code: ${response.statusCode}");
    print("✅ Body: ${responseBody.toString()}");

    if (response.statusCode == 200 || response.statusCode == 422) {
      return jsonDecode(responseBody);
    } else {
      throw Exception("فشل الاتصال بالسيرفر: ${response.statusCode}");
    }
  }


  static Future<Map<String, dynamic>> verifyCode({
    required UserModel user,
    required String code,
  }) async {
    final int? parsedId =user.id;

    if (parsedId == -1) {
      throw Exception("معرّف المستخدم غير صالح");
    }
    final uri = Uri.parse("$baseUrl/verifyAuthCode/${user.id}");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_headers());
    request.fields['code'] = code;

    print(" [VERIFY CODE] URL: $uri");
    print(" Fields: code=$code");

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("✅ Status Code: ${response.statusCode}");
    print("✅ Body: $body");

    if (response.statusCode == 200 || response.statusCode == 422) {
      return jsonDecode(body);
    } else {
      throw Exception("فشل التحقق من الرمز: ${response.statusCode}");
    }
  }


  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse("$baseUrl/login");

    print("[LOGIN] POST $uri");
    print(" Body: email=$email, password=$password");

    final res = await http.post(
      uri,
      headers: _headers(),
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }


  static Future<Map<String, dynamic>> forgetPassword(String email) async {
    final uri = Uri.parse("$baseUrl/forgetPassword");

    print(" [FORGET PASSWORD] POST $uri");
    print(" Body: email=$email");

    final res = await http.post(
      uri,
      headers: _headers(),
      body: {'email': email.trim()},
    );

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }


  static Future<Map<String, dynamic>> verifyPasswordCode({
    required UserModel user,
    required String code,
  }) async {
    final uri = Uri.parse("$baseUrl/verifyPasswordCode/${user.id}");

    print(" [VERIFY PASSWORD CODE] POST $uri");
    print(" Body: code=$code");

    final res = await http.post(
      uri,
      headers: _headers(),
      body: {'code': code},
    );

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }


  static Future<Map<String, dynamic>> resetPassword({
    int ?userId,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse("$baseUrl/resetPassword/$userId");

    print(" [RESET PASSWORD] POST $uri");
    print(" Body: password=$password, confirm=$confirmPassword");

    final res = await http.post(
      uri,
      headers: _headers(),
      body: {
        'password': password,
        'password_confirmation': confirmPassword,
      },
    );

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }


  static Future<Map<String, dynamic>> refreshCode(int ?userId) async {
    final uri = Uri.parse("$baseUrl/refreshCode/$userId");

    print("[REFRESH CODE] GET $uri");

    final res = await http.get(uri, headers: _headers());

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }


  static Future<Map<String, dynamic>> logout() async {
    final uri = Uri.parse("$baseUrl/logout");

    print("[LOGOUT] GET $uri");

    final res = await http.get(uri, headers: _headers(withAuth: true));

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }
}
