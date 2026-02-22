import 'package:ahgzly_salon_app/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/pages/login_page.dart';
import 'package:ahgzly_salon_app/features/booking/presentation/pages/booking_page.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/pages/home_page.dart';
import 'package:ahgzly_salon_app/features/home/presentation/pages/main_wrapper.dart';
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // الفرع الأول: الرئيسية
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // الفرع الثاني: حجوزاتي
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.myAppointments,
                builder: (context, state) => const MyAppointmentsPage(),
              ),
            ],
          ),
          // الفرع الثالث: الملف الشخصي (سنبنيه لاحقاً)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('قريباً'))),
              ),
            ],
          ),
        ],
      ),
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
        builder: (context, state) => const HomePage()
      ),
      GoRoute(
        path: Routes.booking,
        builder: (context, state) {
          // استخراج البيانات الممررة من الشاشة السابقة (Extra)
          final args = state.extra as Map<String, dynamic>;
          return BookingPage(
            branchId: args['branchId'],
            serviceId: args['serviceId'],
            serviceName: args['serviceName'],
          );
        },
      ),
      GoRoute(
        path: Routes.myAppointments,
        builder: (context, state) => const MyAppointmentsPage(),
      ),
    ],
  );
}
