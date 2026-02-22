import '../entities/employee_entity.dart';
import '../repositories/booking_repository.dart';

class GetEmployeesUseCase {
  final BookingRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<List<EmployeeEntity>> call({required int branchId, required int serviceId}) async {
    return await repository.getEmployees(branchId: branchId, serviceId: serviceId);
  }
}
