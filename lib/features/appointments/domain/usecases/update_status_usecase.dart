
import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../repositories/appointments_repository.dart';

class UpdateStatusUseCase {
  final AppointmentsRepository repository;

  UpdateStatusUseCase(this.repository);

  Future<Either<Failure,void>> call(int id, String status) async {
    return await repository.updateStatus(id,status);
  }
}
