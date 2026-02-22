import '../entities/appointment_entity.dart';
import '../repositories/appointments_repository.dart';

class GetMyAppointmentsUseCase {
  final AppointmentsRepository repository;

  GetMyAppointmentsUseCase(this.repository);

  Future<List<AppointmentEntity>> call() async {
    return await repository.getMyAppointments();
  }
}
