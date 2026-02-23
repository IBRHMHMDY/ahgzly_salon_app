import 'package:ahgzly_salon_app/core/network/auth_interceptor.dart';
import 'package:ahgzly_salon_app/features/appointments/data/datasources/appointments_remote_data_source.dart';
import 'package:ahgzly_salon_app/features/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/usecases/get_my_appointments_usecase.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/usecases/update_status_usecase.dart';
import 'package:ahgzly_salon_app/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:ahgzly_salon_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ahgzly_salon_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ahgzly_salon_app/features/booking/domain/usecases/get_employees_usecase.dart';
import 'package:ahgzly_salon_app/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';

// Auth Imports
import 'package:ahgzly_salon_app/features/auth/domain/usecases/logout_usecase.dart';
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

// Booking Imports
import '../../features/booking/data/datasources/booking_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/create_appointment_usecase.dart';
import '../../features/booking/domain/usecases/get_available_slots_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. Core
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // 2. Local Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );

  // 3. Network & Interceptors
  sl.registerLazySingleton<Interceptor>(
    () => AuthInterceptor(authLocalDataSource: sl()),
  );

  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(
    () =>
        DioClient(dio: sl(), authInterceptor: sl()), // حقن الـ Interceptor هنا
  );

  // =========================================================
  // Features - Auth
  // =========================================================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // =========================================================
  // Features - Catalog
  // =========================================================
  sl.registerLazySingleton<CatalogRemoteDataSource>(
    () => CatalogRemoteDataSource(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<CatalogRepository>(
    () => CatalogRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCatalogUseCase(sl()));
  sl.registerFactory<CatalogCubit>(() => CatalogCubit(getCatalogUseCase: sl()));

  // =========================================================
  // Features - Booking
  // =========================================================
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetAvailableSlotsUseCase(sl()));
  sl.registerLazySingleton(() => CreateAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeesUseCase(sl()));

  sl.registerFactory<BookingCubit>(
    () => BookingCubit(
      getAvailableSlotsUseCase: sl(),
      createAppointmentUseCase: sl(),
      getEmployeesUseCase: sl(),
    ),
  );

  // =========================================================
  // Features - Appointments
  // =========================================================
  sl.registerLazySingleton<AppointmentsRemoteDataSource>(
    () => AppointmentsRemoteDataSource(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetMyAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStatusUseCase(sl()));
  sl.registerFactory<AppointmentsCubit>(
    () => AppointmentsCubit(
      getMyAppointmentsUseCase: sl(),
      updateStatusUseCase: sl(),
    ),
  );
}
