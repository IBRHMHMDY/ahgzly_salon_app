import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  );
  Future<void> logout(
    String token,
  ); // أو بدون توكن إذا كنت تعتمد على الـ Interceptor
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // التعديل الأساسي هنا: الاعتماد على DioClient المجهز بالإعدادات
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // استخدمنا dioClient.dio بدلاً من dio فقط
    // واستخدمنا ApiConstants.login لتجنب كتابة المسار يدوياً
    final response = await dioClient.dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    return {
      'user': UserModel.fromJson(response.data['user']),
      'token': response.data['token'],
    };
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    final response = await dioClient.dio.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone,
      },
    );
    return {
      'user': UserModel.fromJson(response.data['user']),
      'token': response.data['token'],
    };
  }

  @override
  Future<void> logout(String token) async {
    await dioClient.dio.post(ApiConstants.logout);
  }
}
