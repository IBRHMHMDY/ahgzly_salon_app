import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioClient {
  final Dio dio;

  DioClient({required this.dio, required Interceptor authInterceptor}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // استخدام الـ AuthInterceptor المنفصل
    dio.interceptors.add(authInterceptor);

    // إضافة LogInterceptor مفيد جداً أثناء التطوير لمعرفة تفاصيل الطلبات
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}
