import 'package:ahgzly_salon_app/features/auth/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    // المسار الافتراضي عند فتح التطبيق
    initialLocation: Routes.login,

    // لاحقاً سنضيف منطق (Redirect) للتحقق مما إذا كان المستخدم يمتلك Token
    // لنوجهه فوراً إلى Routes.home بدلاً من تسجيل الدخول
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('شاشة إنشاء الحساب'))),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('الشاشة الرئيسية - قريباً')),
        ),
      ),
    ],
  );
}
