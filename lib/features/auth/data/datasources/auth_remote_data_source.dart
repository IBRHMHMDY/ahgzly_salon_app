import 'package:ahgzly_salon_app/core/error/api_error_handler.dart';
import 'package:ahgzly_salon_app/core/network/api_constants.dart';
import 'package:ahgzly_salon_app/core/network/dio_client.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource({required this.dioClient});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return response.data;
    } catch (e) {
      // تمرير الخطأ للمعالج المركزي، ثم رمي الـ Failure ليتم التقاطه في الـ Cubit
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
