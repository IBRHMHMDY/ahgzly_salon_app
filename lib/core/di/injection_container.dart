import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';

// Auth Imports
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';

// Catalog Imports
import '../../features/catalog/data/datasources/catalog_remote_data_source.dart';
import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/catalog/domain/usecases/get_catalog_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. Core
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(dio: sl(), secureStorage: sl()),
  );

  // 2. Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(dioClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(loginUseCase: sl(), registerUseCase: sl()),
  );

  // 3. Features - Catalog
  sl.registerLazySingleton<CatalogRemoteDataSource>(
    () => CatalogRemoteDataSource(dioClient: sl()),
  );
  sl.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCatalogUseCase(sl()));
  sl.registerFactory<CatalogCubit>(() => CatalogCubit(getCatalogUseCase: sl()));
}
