import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/error/failures.dart'; // قم بتعديل المسار

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await remoteDataSource.login(email, password);
      await localDataSource.cacheToken(result['token']);
      return Right(result['user']);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final result = await remoteDataSource.register(
        name,
        email,
        password,
        phone,
      );
      await localDataSource.cacheToken(result['token']);
      return Right(result['user']);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null) {
        await remoteDataSource.logout(token);
        await localDataSource.clearToken();
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final token = await localDataSource.getToken();
      if (token != null && token.isNotEmpty) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
