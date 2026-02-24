import 'package:ahgzly_salon_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../auth/data/datasources/auth_local_data_source.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد حركة (Animation) بسيطة لظهور الشعار بشكل احترافي
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();

    // استدعاء دالة الفحص والتوجيه
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // 1. الانتظار لمدة ثانيتين على الأقل لرؤية الشعار (Branding)
    await Future.delayed(const Duration(seconds: 2));

    // 2. فحص التوكن في الخلفية (من الـ LocalDataSource مباشرة)
    final localDataSource = di.sl<AuthLocalDataSource>();
    final token = await localDataSource.getToken();
    final bool isLoggedIn = token != null && token.isNotEmpty;

    // 3. التوجيه بناءً على حالة تسجيل الدخول باستخدام GoRouter
    if (mounted) {
      if (isLoggedIn) {
        context.go(
          Routes.home,
        ); // استبدلها بمسار الشاشة الرئيسية الخاص بك (مثل /catalog)
      } else {
        context.go(Routes.login);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدم اللون الرئيسي لتطبيقك هنا
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // يمكنك استبدال الأيقونة بصورة الشعار (Image.asset) لاحقاً
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.cut, // أيقونة صالون مؤقتة
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ahgzly Salon',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'احجز موعدك بسهولة',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
