import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_remote_data_source.dart';
import '../models/appointment_model.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AppointmentEntity>> getMyAppointments() async {
    final remoteData = await remoteDataSource.getMyAppointments();

    // تحويل كل JSON Map إلى AppointmentModel (الذي هو بالأساس Entity)
    return remoteData
        .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    await remoteDataSource.updateAppointmentStatus(id, status);
  }
}
