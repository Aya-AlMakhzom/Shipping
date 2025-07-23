import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testt/model/QuestionModel.dart';
import 'package:testt/model/SupplierModel.dart';
import 'package:testt/model/UserModel.dart';

import 'model/CategoryModel.dart';
import 'model/ShipmentModel.dart';

class ApiService {
  static const String baseUrl = "https://pink-scorpion-423797.hostingersite.com";
  static String? token;


  static Map<String, String> _headers({bool withAuth = false}) {
    final languageCode = Get.locale?.languageCode ?? 'ar'; // أو 'en'
    final headers = {
      'Accept': 'application/json',
      'Accept-Language': languageCode,
    };
    if (withAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }


  static Future<Map<String, dynamic>> register(Map<String, String> body) async {
    final uri = Uri.parse("$baseUrl/api/auth/register");
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
    final uri = Uri.parse("$baseUrl/api/auth/verifyAuthCode/${user.id}");
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
    final uri = Uri.parse("$baseUrl/api/auth/login");

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
    final uri = Uri.parse("$baseUrl/api/auth/forgetPassword");

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
    final uri = Uri.parse("$baseUrl/api/auth/verifyPasswordCode/${user.id}");

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
    final uri = Uri.parse("$baseUrl/api/auth/resetPassword/$userId");

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
    final uri = Uri.parse("$baseUrl/api/auth/refreshCode/$userId");

    print("[REFRESH CODE] GET $uri");

    final res = await http.get(uri, headers: _headers());

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }


  static Future<Map<String, dynamic>> logout() async {
    final uri = Uri.parse("$baseUrl/api/auth/logout");

    print("[LOGOUT] GET $uri");

    final res = await http.get(uri, headers: _headers(withAuth: true));

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${res.body}");

    return jsonDecode(res.body);
  }

  static Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse("$baseUrl/api/categories/");
    print("🚀 [getCategories] بدء طلب الكاتيجوري من: $uri");

    try {
      final response = await http.get(uri, headers: _headers(withAuth: true));
      print("✅ [getCategories] رمز الاستجابة: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print("📦 [getCategories] البيانات المُستلمة: $decoded");

        if (decoded['status'] == 1) {
          final categoriesJson = decoded['data']['categories'] as List;
          print("🔢 [getCategories] عدد الكاتيجوري المستلمة: ${categoriesJson.length}");

          final categories = categoriesJson.map((json) {
            try {
              return CategoryModel.fromJson(json);
            } catch (e) {
              print("⚠️ [getCategories] خطأ عند تحويل عنصر: $e");
              return null;
            }
          }).whereType<CategoryModel>().toList();

          print("✅ [getCategories] تم تحويل ${categories.length} كاتيجوري بنجاح");
          return categories;
        } else {
          print("⚠️ [getCategories] الحالة ليست 1، الرسالة: ${decoded['message']}");
        }
      } else {
        print("❌ [getCategories] رمز استجابة غير متوقع: ${response.statusCode}");
      }
    } catch (e) {
      print("🔥 [getCategories] استثناء أثناء الطلب: $e");
    }

    return [];
  }
  static Future<Map<String, dynamic>> postShipment(ShipmentModel shipment) async {
    final uri = Uri.parse("$baseUrl/api/shipment");
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_headers(withAuth: true));

    shipment.toJson().forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString().trim();
      }
    });

    print("[POST SHIPMENT] POST $uri");
    print(" Headers: ${request.headers}");
    print(" Fields: ${request.fields}");

    final res = await request.send();
    final responseBody = await res.stream.bytesToString();

    print("✅ Status Code: ${res.statusCode}");
    print("✅ Body: ${responseBody.toString()}");

    if (res.statusCode == 200 || res.statusCode == 422) {
      return jsonDecode(responseBody);
    } else {
      throw Exception("فشل الاتصال بالسيرفر: ${res.statusCode}");
    }
  }



  static Future<ApiResponse<SupplierModel>> postSupplier(SupplierModel supplier) async {
    final uri = Uri.parse("$baseUrl/api/supplier");
    try {
      final response = await http.post(
        uri,
        headers: _headers(withAuth: true),
        body: supplier.toFormData(),
      );

      final decoded = jsonDecode(response.body);
      print("📨 [postSupplier] response: $decoded");

      return ApiResponse.fromJson(
        decoded,
            (data) => SupplierModel.fromJson(data),
      );
    } catch (e) {
      print("❌ [postSupplier] Exception: $e");
      return ApiResponse(status: 0, data: null, message: 'فشل الاتصال بالخادم');
    }
  }


  static Future<List<QuestionModel>> getQuestionsByCategory(int categoryId) async {
    final uri = Uri.parse('$baseUrl/api/questions/$categoryId');
    final response = await http.get(uri, headers: _headers(withAuth: true));
    print("📤 Endpoint: $uri");
    print("📥 Status Code: ${response.statusCode}");
    print("📥 Body: ${response.body}");
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == 1) {
        final questionsJson = decoded['data']['question'] as List;
        return questionsJson.map((e) => QuestionModel.fromJson(e)).toList();
      }
    }
    return [];
  }


  static Future<void> postShipmentAnswers({
    required int shipmentId,
    required List<Map<String, dynamic>> answers,
  }) async {
    final uri = Uri.parse('$baseUrl/api/shipment-answers');
    final request = http.MultipartRequest('POST', uri);

    final headers = _headers(withAuth: true);
    request.headers.addAll(headers);


    request.fields['shipment_id'] = shipmentId.toString();


    for (int i = 0; i < answers.length; i++) {
      request.fields['answers[$i][shipment_question_id]'] = answers[i]['question_id'].toString();
      request.fields['answers[$i][answer]'] = answers[i]['answer'].toString();
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📤 [postShipmentAnswers] Sent Fields: ${request.fields}");
      print("📥 Status Code: ${response.statusCode}");
      print("📥 Body: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == 1) {
        Get.snackbar("نجاح", "تم إرسال الإجابات بنجاح");
      } else {
        Get.snackbar("فشل", decoded['message'].toString());
      }
    } catch (e) {
      print("❌ [postShipmentAnswers] Error: $e");
      Get.snackbar("خطأ", "فشل الاتصال بالخادم");
    }
  }


}
