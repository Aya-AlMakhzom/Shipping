import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/register_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "مرحبًا بك!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF081F5C),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "يرجى إدخال معلوماتك لإنشاء حساب جديد",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                _buildInput("الاسم", Icons.person, controller.nameController),
                _buildInput("اسم الأب", Icons.person_outline, controller.fNameController),
                _buildInput("النسب", Icons.person_2_outlined, controller.nNameController),
                _buildInput("البريد الإلكتروني", Icons.email, controller.emailController, keyboard: TextInputType.emailAddress),
                _buildInput("كلمة المرور", Icons.lock, controller.passwordController, obscure: true),
                _buildInput("رقم الهاتف", Icons.phone, controller.phoneController, keyboard: TextInputType.phone),

                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF334EAC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: controller.register,
                  child: const Text("تسجيل", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, TextEditingController controller,
      {bool obscure = false, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF334EAC)),
          filled: true,
          fillColor: const Color(0xFFE7F1FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
