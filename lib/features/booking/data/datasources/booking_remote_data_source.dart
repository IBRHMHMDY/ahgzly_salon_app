import 'package:ahgzly_salon_app/core/network/dio_client.dart';
import 'package:ahgzly_salon_app/core/network/error_handler.dart';

class BookingRemoteDataSource {
  final DioClient dioClient;

  BookingRemoteDataSource({required this.dioClient});

  Future<List<dynamic>> getEmployees({
    required int branchId,
    required int serviceId,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/catalog/staff',
        queryParameters: {'branch_id': branchId, 'service_id': serviceId},
      );
      // التأكد من استخراج القائمة بأمان
      if (response.data is Map && response.data.containsKey('data')) {
        return response.data['data'] as List<dynamic>;
      }

      return [];
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getAvailableSlots({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/appointments/slots',
        queryParameters: {
          'branch_id': branchId,
          'employee_id': employeeId,
          'service_id': serviceId,
          'date': date,
        },
      );
      // استخدام المفتاح الصحيح القادم من اللوجات الخاصة بك
      if (response.data is Map &&
          response.data.containsKey('available_slots')) {
        return response.data['available_slots'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // 💥 إنشاء الحجز يأخذ المعطيات الحقيقية
  Future<void> createAppointment({
    required int branchId,
    required int employeeId,
    required int serviceId,
    required String date,
    required String startTime,
  }) async {
    try {
      await dioClient.dio.post(
        '/appointments/create',
        data: {
          'branch_id': branchId,
          'employee_id': employeeId,
          'service_id': serviceId,
          'date': date,
          'start_time': startTime,
        },
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
