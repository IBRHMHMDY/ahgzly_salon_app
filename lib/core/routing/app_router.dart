import 'package:go_router/go_router.dart';

class AppRouter {
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String homePath = '/'; // مسار الـ Catalog لاحقاً

  static final GoRouter router = GoRouter(
    initialLocation: loginPath, // سنعدلها لاحقاً بناءً على وجود التوكن أم لا
    routes: [
      GoRoute(
        path: loginPath,
        // builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: registerPath,
        // builder: (context, state) => const RegisterScreen(),
      ),
      // ستتم إضافة مسارات الـ Catalog والحجوزات هنا
    ],
  );
}
