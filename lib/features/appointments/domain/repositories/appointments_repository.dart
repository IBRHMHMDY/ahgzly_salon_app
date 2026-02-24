import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments();
  Future<Either<Failure,void>> updateStatus(int id, String status);
}
