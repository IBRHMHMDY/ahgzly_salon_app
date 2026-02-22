import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة حقن الاعتماديات (GetIt)
  await di.init();

  runApp(const AhgzlyApp());
}

class AhgzlyApp extends StatelessWidget {
  const AhgzlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا MaterialApp.router بدلاً من MaterialApp العادية
    return MaterialApp.router(
      title: 'Ahgzly Salon',
      debugShowCheckedModeBanner: false,

      // تطبيق التصميم الموحد (Theme)
      theme: AppTheme.lightTheme,

      // تطبيق نظام التوجيه (GoRouter)
      routerConfig: AppRouter.router,
    );
  }
}
