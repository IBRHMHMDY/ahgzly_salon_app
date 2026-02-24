import 'package:ahgzly_salon_app/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:ahgzly_salon_app/features/auth/domain/entities/user_entity.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/pages/login_page.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/pages/profile_page.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/pages/register_page.dart';
import 'package:ahgzly_salon_app/features/booking/presentation/pages/booking_page.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/pages/home_page.dart';
import 'package:ahgzly_salon_app/features/home/presentation/pages/main_wrapper.dart';
import 'package:ahgzly_salon_app/features/splash/presentation/pages/splash_page.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouter {
  
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      // 1. مسارات الـ Tabs (Bottom Navigation Bar)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // MyAppointments
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.myAppointments,
                builder: (context, state) => const MyAppointmentsPage(),
              ),
            ],
          ),
          // MyProfile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // 2. المسارات المستقلة (بدون Bottom Navigation Bar)
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (context, state) {
          // نستقبل بيانات المستخدم الحالية لملء الحقول مسبقاً
          final user = state.extra as UserEntity;
          return EditProfilePage(user: user);
        },
      ),
      GoRoute(
        path: Routes.booking,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return BookingPage(
            branchId: args['branchId'] ?? 0,
            serviceId: args['serviceId'] ?? 0,
            serviceName: args['serviceName'] ?? 'حجز خدمة',
          );
        },
      ),
    ],
  );
}
