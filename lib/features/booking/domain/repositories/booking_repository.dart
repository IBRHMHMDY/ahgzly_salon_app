import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:ahgzly_salon_app/features/booking/domain/entities/employee_entity.dart';
import 'package:dartz/dartz.dart';

import '../entities/slot_entity.dart';

abstract class BookingRepository {
  // جلب الموظفين بناءً على الفرع
  Future<Either<Failure,List<EmployeeEntity>>> getEmployees({required int branchId, required int serviceId});
  // جلب الأوقات المتاحة بناءً على التاريخ، الخدمة، والفرع
  Future<Either<Failure,List<SlotEntity>>> getAvailableSlots({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
  });
  // إنشاء الحجز
  Future<Either<Failure,void>> createAppointment({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
    required String startTime,

  });
}
