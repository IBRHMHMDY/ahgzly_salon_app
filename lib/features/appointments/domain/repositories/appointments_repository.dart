import '../entities/appointment_entity.dart';

abstract class AppointmentsRepository {
  Future<List<AppointmentEntity>> getMyAppointments();
  Future<void> updateStatus(int id, String status);
}
