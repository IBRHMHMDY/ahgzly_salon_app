import 'package:ahgzly_salon_app/core/error/failures.dart';
import 'package:ahgzly_salon_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:ahgzly_salon_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // الاعتماد على الـ UseCases بدلاً من الـ Repository
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      // استدعاء UseCase
      await loginUseCase(email, password);
      emit(AuthSuccess());
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError("حدث خطأ غير متوقع."));
    }
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    emit(AuthLoading());
    try {
      await registerUseCase(name, email, phone, password);
      emit(AuthSuccess());
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError("حدث خطأ غير متوقع."));
    }
  }
}
