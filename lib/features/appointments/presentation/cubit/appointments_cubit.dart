import 'package:ahgzly_salon_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/usecases/get_my_appointments_usecase.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/usecases/update_status_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetMyAppointmentsUseCase getMyAppointmentsUseCase;
  final UpdateStatusUseCase updateStatusUseCase;

  AppointmentsCubit({
    required this.getMyAppointmentsUseCase,
    required this.updateStatusUseCase,
  }) : super(AppointmentsInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentsLoading());
    try {
      final appointments = await getMyAppointmentsUseCase();
      emit(AppointmentsLoaded(appointments));
    } on Failure catch (failure) {
      emit(AppointmentsError(failure.message));
    } catch (e) {
      emit(AppointmentsError("حدث خطأ غير متوقع أثناء جلب الحجوزات."));
    }
  }

  Future<void> updateStatus(int id, String status) async {
    // لا نريد تغيير الحالة العامة للتحميل (Loading) لكي لا تختفي القائمة
    // سنستخدم حالة بسيطة أو نتعامل مع الـ UI مباشرة
    try {
      await updateStatusUseCase(id, status);
      // عند النجاح، نعيد جلب الحجوزات لتحديث الواجهة تلقائياً
      await fetchAppointments();
    } on Failure catch (failure) {
      emit(AppointmentsError(failure.message));
    }
  }
}
