import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:ahgzly_salon_app/features/appointments/data/datasources/appointments_remote_data_source.dart';
import 'package:ahgzly_salon_app/features/appointments/data/models/appointment_model.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:ahgzly_salon_app/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:dartz/dartz.dart';


class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource remoteDataSource;

  AppointmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AppointmentEntity>>> getMyAppointments() async {
    final remoteData = await remoteDataSource.getMyAppointments();

    final appointments = remoteData
        .map<AppointmentEntity>(
          (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
    return Right(appointments);
  }

  @override
  Future<Either<Failure, void>> updateStatus(int id, String status) async {
    try {
      await remoteDataSource.updateAppointmentStatus(
        id,
        status,
      );
      return Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
