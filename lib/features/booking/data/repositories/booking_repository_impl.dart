import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/slot_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/employee_model.dart';
import '../models/slot_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EmployeeEntity>> getEmployees({required int branchId, required int serviceId}) async {
    final remoteEmployees = await remoteDataSource.getEmployees(
      branchId: branchId, serviceId: serviceId
    );
    return remoteEmployees.map((json) => EmployeeModel.fromJson(json)).toList();
  }

 @override
  Future<List<SlotEntity>> getAvailableSlots({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
  }) async {
    final List<dynamic> remoteSlots = await remoteDataSource.getAvailableSlots(
      branchId: branchId,
      employeeId: employeeId,
      serviceId: serviceId,
      date: date,
    );

    return remoteSlots
        .map((time) => SlotModel.fromString(time.toString()))
        .toList();
  }

  @override
  Future<void> createAppointment({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
    required String startTime,

  }) async {
    await remoteDataSource.createAppointment(
      branchId: branchId,
      employeeId: employeeId,
      serviceId: serviceId,
      date: date,
      startTime: startTime,

    );
  }
}
