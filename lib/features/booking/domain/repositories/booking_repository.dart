import 'package:ahgzly_salon_app/features/booking/domain/entities/employee_entity.dart';

import '../entities/slot_entity.dart';

abstract class BookingRepository {
  // جلب الموظفين بناءً على الفرع
  Future<List<EmployeeEntity>> getEmployees({required int branchId, required int serviceId});
  // جلب الأوقات المتاحة بناءً على التاريخ، الخدمة، والفرع
  Future<List<SlotEntity>> getAvailableSlots({
    required int branchId,
    required int employeeId, // تأكد من وجود هذا السطر
    required int serviceId,
    required String date,
  });
  // إنشاء الحجز
  Future<void> createAppointment({
    required int branchId,
    required int employeeId, // يمكن أن يكون افتراضياً 1 في الـ MVP
    required int serviceId,
    required String date,
    required String startTime,

  });
}
