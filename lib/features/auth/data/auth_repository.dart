import '../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  Future<String> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      // استخراج التوكن بناءً على استجابة Sanctum
      return response.data['token'];
    } catch (e) {
      throw Exception('فشل تسجيل الدخول، تأكد من بياناتك.');
    }
  }
}
