import '../repositories/booking_repository.dart';

class CreateAppointmentUseCase {
  final BookingRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<void> call({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
    required String startTime,

  }) async {
    return await repository.createAppointment(
      branchId: branchId,
      employeeId: employeeId,
      serviceId: serviceId,
      date: date,
      startTime: startTime,

    );
  }
}
