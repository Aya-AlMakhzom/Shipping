import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/model/UserModel.dart';
import '../api_service.dart.dart';
import '../view/home_page.dart';



class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();
  final isLoading = false.obs;


  void login() async {
    emailError.value = null;
    passwordError.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      emailError.value = email.isEmpty ? "البريد الإلكتروني مطلوب" : null;
      passwordError.value = password.isEmpty ? "كلمة المرور مطلوبة" : null;
      return;
    }

    isLoading.value = true;
    final response = await ApiService.login(email: email, password: password);
    isLoading.value = false;
    if (response['status'] == 1) {
      UserModel user =UserModel.fromJson(response['data']['user']);
      user.setTOKEN(response['data']['token']);
      user.setIsVerified(true);
      ApiService.token = response['data']['token'];
      Future.delayed(Duration(milliseconds: 100), () {
        Get.offAll(() => const HomePage());
      });
    } else {
      Get.snackbar(
        "خطأ",
        response['message'] ?? "حدث خطأ غير متوقع",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
