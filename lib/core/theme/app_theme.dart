import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // تأكد من إضافة google_fonts في pubspec.yaml
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      // إعداد خط Cairo ليكون الخط الافتراضي للتطبيق كاملاً
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.secondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondary),
        titleTextStyle: TextStyle(
          color: AppColors.secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50), // زر بعرض الشاشة
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // حواف دائرية عصرية
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
