import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/view/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Import Export App',
      theme:ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FCFF),
    primaryColor: const Color(0xFF334EAC),
    appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF081F5C),
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFE7F1FF),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFDDE3FF)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF334EAC),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
    textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF081F5C), fontSize: 18),
    bodyMedium: TextStyle(color: Color(0xFF081F5C), fontSize: 16),
    ),
    ),

    home: const LoginView(),
    );
  }
}
