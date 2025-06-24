import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_service.dart.dart';
import '../model/UserModel.dart';
import '../view/verify_code_view.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final fNameController = TextEditingController();
  final nNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  void register() async {
    final user = UserModel(
      firstName: nameController.text,
      secondName: fNameController.text,
      thirdName: nNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      isVerified: false,
    );

    try {
      final response = await ApiService.register(user.toMap());

      if (response['status'] == 1) {
        UserModel registeredUser = response['data']['user'];
        Get.to(() => VerifyCodeView(
          source: 'register',
          user: registeredUser,
        ));
      } else {
        Get.snackbar("خطأ", response['message'] ?? "فشل التسجيل");
      }
    } catch (_) {
      Get.snackbar("خطأ", "حدث خطأ في الاتصال بالسيرفر");
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    fNameController.dispose();
    nNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
