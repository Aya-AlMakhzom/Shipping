
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/controller/reset_password_controller.dart';
import 'package:testt/model/UserModel.dart';
import '../api_service.dart.dart';
import '../view/home_page.dart';
import '../view/reset_password_view.dart';

class VerifyCodeController extends GetxController {
  final String source; // 'register', 'reset',
  final UserModel user;

  VerifyCodeController({
    required this.source,
    required this.user,
  });

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> controllers = List.generate(6, (_) => TextEditingController());
  final RxnString error = RxnString();

  String getCode() => controllers.map((c) => c.text).join();

  void handleInput(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyCode() async {
    final code = getCode();
    if (code.length < 6) {
      error.value = "الرجاء إدخال الكود الكامل";
      return;
    }

    try {
      late Map<String, dynamic> response;

      if (source == 'reset') {
        response = await ApiService.verifyPasswordCode(user: user, code: code);
      } else {
        response = await ApiService.verifyCode(user: user, code: code);
        user.setTOKEN(response['data']['token']);
        user.setIsVerified(true);
      }

      if (response['status'] == 1) {
        handleSuccess();
      } else {
        error.value = response['message'] ?? "رمز التحقق غير صحيح";
      }
    } catch (_) {
      error.value = "حدث خطأ أثناء التحقق من الرمز";
    }
  }

  void handleSuccess() {
    if (source == 'register') {
      Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
      Get.offAll(() => const HomePage());
    } else if (source == 'reset') {
      Get.to(() => ResetPasswordView(
        controller: ResetPasswordController(user: user),
      ));

    } else if (source == 'login') {
      Get.snackbar("تم التحقق", "تم تسجيل الدخول بنجاح");
      Get.offAll(() => const HomePage());
    }
  }
}
