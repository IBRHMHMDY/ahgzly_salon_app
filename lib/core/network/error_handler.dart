import 'package:dio/dio.dart';

// تعريف كلاس الفشل الموحد
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// دالة لمعالجة أخطاء Dio وتحويلها لرسالة واضحة
class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ConnectionFailure(
            "انتهت مهلة الاتصال، يرجى التحقق من الإنترنت",
          );
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return const ConnectionFailure("تم إلغاء الطلب");
        case DioExceptionType.connectionError:
          return const ConnectionFailure("لا يوجد اتصال بالإنترنت");
        case DioExceptionType.unknown:
          return const ServerFailure("حدث خطأ غير متوقع، حاول مرة أخرى");
        default:
          return const ServerFailure("حدث خطأ ما");
      }
    } else {
      return ServerFailure(error.toString());
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) return ServerFailure("استجابة غير معروفة من الخادم");

    final statusCode = response.statusCode;
    final data = response.data;

    try {
      if (statusCode == 401 || statusCode == 403) {
        return const ServerFailure("غير مصرح لك، يرجى تسجيل الدخول مرة أخرى");
      } else if (statusCode == 404) {
        return const ServerFailure("الرابط غير موجود أو البيانات محذوفة");
      } else if (statusCode == 422) {
        // معالجة أخطاء الـ Validation الخاصة بـ Laravel
        // Laravel returns: { "message": "...", "errors": { "field": ["error"] } }
        if (data is Map<String, dynamic>) {
          if (data.containsKey('errors')) {
            final errors = data['errors'] as Map<String, dynamic>;
            // نأخذ أول خطأ فقط لعرضه للمستخدم
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return ServerFailure(firstError.first.toString());
            }
          }
          return ServerFailure(data['message'] ?? "بيانات غير صالحة");
        }
      } else if (statusCode == 500) {
        return const ServerFailure(
          "خطأ في الخادم الداخلي، يرجى المحاولة لاحقاً",
        );
      }
    } catch (e) {
      return const ServerFailure("فشل في قراءة استجابة الخادم");
    }

    return ServerFailure(data['message'] ?? "حدث خطأ غير معروف ($statusCode)");
  }
}
