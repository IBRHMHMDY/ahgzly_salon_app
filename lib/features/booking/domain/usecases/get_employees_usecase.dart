import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../entities/employee_entity.dart';
import '../repositories/booking_repository.dart';

class GetEmployeesUseCase {
  final BookingRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<Either<Failure,List<EmployeeEntity>>> call({required int branchId, required int serviceId}) async {
    return await repository.getEmployees(branchId: branchId, serviceId: serviceId);
  }
}
