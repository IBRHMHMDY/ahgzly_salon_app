import 'package:ahgzly_salon_app/core/network/dio_client.dart';
import 'package:ahgzly_salon_app/core/network/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  );
  Future<void> logout();
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(String name, String email, String phone);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
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
  Future<void> logout() async {
    await dioClient.dio.post(ApiConstants.logout);
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await dioClient.dio.get(ApiConstants.profile);
    final data =
        response.data['data'] ?? response.data['user'] ?? response.data;
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateProfile(
    String name,
    String email,
    String phone,
  ) async {
    final response = await dioClient.dio.put(
      ApiConstants.profile,
      data: {'name': name, 'email': email, 'phone': phone},
    );

    final data =
        response.data['data'] ?? response.data['user'] ?? response.data;
    return UserModel.fromJson(data);
  }
}
