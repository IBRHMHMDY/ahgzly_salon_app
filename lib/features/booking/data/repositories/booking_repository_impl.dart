import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:ahgzly_salon_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:ahgzly_salon_app/features/booking/data/models/employee_model.dart';
import 'package:ahgzly_salon_app/features/booking/data/models/slot_model.dart';
import 'package:ahgzly_salon_app/features/booking/domain/entities/employee_entity.dart';
import 'package:ahgzly_salon_app/features/booking/domain/entities/slot_entity.dart';
import 'package:ahgzly_salon_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:dartz/dartz.dart';


class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});
@override
Future<Either<Failure, List<EmployeeEntity>>> getEmployees({
  required int branchId,
  required int serviceId,
}) async {
  try {
    final remoteEmployees = await remoteDataSource.getEmployees(
      branchId: branchId,
      serviceId: serviceId,
    );
    
        final employees = remoteEmployees
            .map<EmployeeEntity>((json) => EmployeeModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(employees);
  } catch (e) {
    return Left(ErrorHandler.handle(e));
  }
}

  @override
  Future<Either<Failure, List<SlotEntity>>> getAvailableSlots({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
  }) async {
    try {
      final List<dynamic> remoteSlots = await remoteDataSource
          .getAvailableSlots(
            branchId: branchId,
            employeeId: employeeId,
            serviceId: serviceId,
            date: date,
          );

      final slots = remoteSlots
          .map<SlotEntity>((time) => SlotModel.fromString(time.toString()))
          .toList();
      return Right(slots);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> createAppointment({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
    required String startTime,
  }) async {
    try {
      await remoteDataSource.createAppointment(
        branchId: branchId,
        employeeId: employeeId,
        serviceId: serviceId,
        date: date,
        startTime: startTime,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
