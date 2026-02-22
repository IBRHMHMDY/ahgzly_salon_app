import 'package:ahgzly_salon_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ahgzly_salon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// لاحظ استخدام implements
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<void> login(String email, String password) async {
    final data = await remoteDataSource.login(email, password);
    final token = data['token'];
    await secureStorage.write(key: 'auth_token', value: token);
  }

  @override
  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final data = await remoteDataSource.register(name, email, phone, password);
    final token = data['token'];
    await secureStorage.write(key: 'auth_token', value: token);
  }
}
