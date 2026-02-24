import 'package:ahgzly_salon_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final failureOrStatus = await checkAuthStatusUseCase();

    failureOrStatus.fold((failure) => emit(Unauthenticated()), (
      isAuthenticated,
    ) async {
      if (isAuthenticated) {
        // جلب بيانات المستخدم لأن التوكن موجود
        final failureOrUser = await getProfileUseCase();
        failureOrUser.fold(
          (failure) => emit(Unauthenticated()),
          (user) => emit(Authenticated(user: user)),
        );
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> getProfile() async {
    emit(AuthLoading());
    final failureOrUser = await getProfileUseCase();

    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }
Future<void> updateProfile(String name, String email, String phone) async {
    emit(AuthLoading());
    final failureOrUser = await updateProfileUseCase(name, email, phone);

    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      // عند النجاح، نحدث الحالة ببيانات المستخدم الجديدة ليتغير اسمه فوراً في التطبيق
      (user) => emit(Authenticated(user: user)),
    );
  }
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final failureOrUser = await loginUseCase(email, password);

    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await registerUseCase(name, email, password, phone);

    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final failureOrSuccess = await logoutUseCase();

    failureOrSuccess.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  void forceLogout() {
    emit(Unauthenticated());
  }
}
