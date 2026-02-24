import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../entities/slot_entity.dart';
import '../repositories/booking_repository.dart';

class GetAvailableSlotsUseCase {
  final BookingRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  // 💥 إضافة employeeId للمعاملات المطلوبة
  Future<Either<Failure,List<SlotEntity>>> call({
    required int branchId,
    required int employeeId, // تم الإضافة هنا
    required int serviceId,
    required String date,
  }) async {
    return await repository.getAvailableSlots(
      branchId: branchId,
      employeeId: employeeId, // تمريره للمستودع
      serviceId: serviceId,
      date: date,
    );
  }
}
