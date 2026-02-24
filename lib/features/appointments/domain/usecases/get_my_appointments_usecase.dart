import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:dartz/dartz.dart';


class GetMyAppointmentsUseCase {
  final AppointmentsRepository repository;

  GetMyAppointmentsUseCase(this.repository);

  Future<Either<Failure,List<AppointmentEntity>>> call() async {
    return await repository.getMyAppointments();
  }
}
