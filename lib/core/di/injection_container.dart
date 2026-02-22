import 'package:ahgzly_salon_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ahgzly_salon_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ahgzly_salon_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ahgzly_salon_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ahgzly_salon_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance; // sl: Service Locator

Future<void> init() async {
  // Core
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<DioClient>(
    () => DioClient(dio: sl(), secureStorage: sl()),
  );

  // Features
  // 1. Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(dioClient: sl()),
  );

  // ربط الـ Abstract بالـ Implementation
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()),
  );

  // تسجيل الـ UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // تحديث الـ Cubit
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(loginUseCase: sl(), registerUseCase: sl()),
  );
}
