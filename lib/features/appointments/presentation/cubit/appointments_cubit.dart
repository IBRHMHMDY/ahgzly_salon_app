import 'package:ahgzly_salon_app/features/appointments/domain/usecases/get_my_appointments_usecase.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/usecases/update_status_usecase.dart';
import 'package:ahgzly_salon_app/features/appointments/presentation/cubit/appointments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetMyAppointmentsUseCase getMyAppointmentsUseCase;
  final UpdateStatusUseCase updateStatusUseCase;

  AppointmentsCubit({
    required this.getMyAppointmentsUseCase,
    required this.updateStatusUseCase,
  }) : super(AppointmentsInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentsLoading());
    final result = await getMyAppointmentsUseCase();
    result.fold(
      (failure) => emit(AppointmentsError(failure.message)),
      (appointments) => emit(AppointmentsLoaded(appointments)),
    );
  }

  Future<void> updateStatus(int id, String status) async {
    // لا نريد تغيير الحالة العامة للتحميل (Loading) لكي لا تختفي القائمة
    // سنستخدم حالة بسيطة أو نتعامل مع الـ UI مباشرة
    final result = await updateStatusUseCase(id, status);
    result.fold(
      (failure) => emit(AppointmentsError(failure.message)),
      (_) => fetchAppointments(),
    );
  }

  // دالة لتصفير البيانات عند تسجيل الخروج
  void reset() {
    emit(AppointmentsInitial());
  }
}
