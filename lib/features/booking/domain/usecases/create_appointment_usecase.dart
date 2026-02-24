import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:ahgzly_salon_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:dartz/dartz.dart';

class CreateAppointmentUseCase {
  final BookingRepository repository;

  CreateAppointmentUseCase(this.repository);

  Future<Either<Failure, void>> call({
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
