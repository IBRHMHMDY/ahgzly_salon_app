import 'package:dio/dio.dart';
import 'failures.dart';

class ApiErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      // التعامل مع أخطاء Dio (الشبكة والاتصال)
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkFailure(
            "انتهى وقت الاتصال بالسيرفر، يرجى المحاولة لاحقاً.",
          );
        case DioExceptionType.connectionError:
          return NetworkFailure("لا يوجد اتصال بالإنترنت، تأكد من الشبكة.");
        case DioExceptionType.cancel:
          return ServerFailure("تم إلغاء الطلب.");
        case DioExceptionType.badResponse:
          // التعامل مع أخطاء الـ Backend (Laravel)
          return _handleBadResponse(error.response);
        case DioExceptionType.unknown:
        default:
          return ServerFailure("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.");
      }
    } else {
      // أخطاء أخرى غير متوقعة (مثل أخطاء في الكود نفسه)
      return ServerFailure("حدث خطأ غير معروف: ${error.toString()}");
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return ServerFailure("استجابة فارغة من السيرفر.");
    }

    final statusCode = response.statusCode;
    final data = response.data;

    // محاولة استخراج رسالة الخطأ المباشرة من Laravel إن وجدت
    String? message;
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'];
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(message ?? "طلب غير صالح (Bad Request).");
      case 401:
        return ServerFailure(
          message ?? "غير مصرح لك، يرجى تسجيل الدخول مجدداً.",
        );
      case 403:
        return ServerFailure(message ?? "ليس لديك صلاحية للقيام بهذا الإجراء.");
      case 404:
        return ServerFailure(message ?? "الرابط أو العنصر المطلوب غير موجود.");
      case 422:
        // معالجة أخطاء الـ Validation الخاصة بـ Laravel بشكل احترافي
        // Laravel يُرجع الأخطاء داخل كائن 'errors'
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>;
          if (errors.isNotEmpty) {
            // جلب أول رسالة خطأ من القائمة لعرضها للمستخدم
            final firstErrorKey = errors.keys.first;
            final firstErrorMessage = errors[firstErrorKey][0];
            return ValidationFailure(firstErrorMessage.toString());
          }
        }
        return ValidationFailure(message ?? "بيانات غير صالحة.");
      case 500:
        return ServerFailure("خطأ داخلي في السيرفر، المبرمجون يعملون على حله.");
      default:
        return ServerFailure(
          message ?? "حدث خطأ غير متوقع (كود: $statusCode).",
        );
    }
  }
}
