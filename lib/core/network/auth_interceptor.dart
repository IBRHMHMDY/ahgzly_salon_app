import 'package:ahgzly_salon_app/core/di/injection_container.dart';
import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
// تأكد من المسار الصحيح لديك
import '../../features/auth/data/datasources/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;

  AuthInterceptor({required this.authLocalDataSource});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // جلب التوكن من التخزين المحلي
    final token = await authLocalDataSource.getToken();

    // إذا كان التوكن موجوداً، أضفه إلى الـ Headers
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // يمكنك إضافة headers أخرى هنا مثل لغة التطبيق
    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await authLocalDataSource.clearToken();
      try {
        sl<AuthCubit>().forceLogout();
      } catch (e) {
        throw ErrorHandler.handle(e);
      }
    }
    super.onError(err, handler);
  }
}
