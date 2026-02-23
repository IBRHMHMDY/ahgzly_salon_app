import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final failureOrStatus = await checkAuthStatusUseCase();

    failureOrStatus.fold((failure) => emit(Unauthenticated()), (
      isAuthenticated,
    ) {
      if (isAuthenticated) {
        // ملاحظة: إذا كنت بحاجة لبيانات المستخدم عند فتح التطبيق،
        // ستحتاج لعمل Endpoint لجلب بيانات الـ Profile واستدعائها هنا.
        // حالياً سنكتفي بتغيير الحالة إذا كان التوكن موجوداً.
        emit(Unauthenticated()); // أو استدعاء User Profile إذا كان متوفراً
      } else {
        emit(Unauthenticated());
      }
    });
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
}
