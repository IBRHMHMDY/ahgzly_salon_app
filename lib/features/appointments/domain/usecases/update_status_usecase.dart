
import '../repositories/appointments_repository.dart';

class UpdateStatusUseCase {
  final AppointmentsRepository repository;

  UpdateStatusUseCase(this.repository);

  Future<void> call(int id, String status) async {
    return await repository.updateStatus(id,status);
  }
}
