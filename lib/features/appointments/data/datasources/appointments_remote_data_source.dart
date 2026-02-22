import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/error/api_error_handler.dart';

class AppointmentsRemoteDataSource {
  final DioClient dioClient;

  AppointmentsRemoteDataSource({required this.dioClient});

  Future<List<dynamic>> getMyAppointments() async {
    try {
      final response = await dioClient.dio.get('/appointments/my-appointments');

      if (response.data is Map && response.data.containsKey('appointments')) {
        return response.data['appointments'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> updateAppointmentStatus(int id, String status) async {
    try {
      await dioClient.dio.post('/appointments/$id/status', data: {
        'status': status,
        '_method': 'POST',
      });
    } catch (e) {
      if (e is DioException) {
        print("Backend Error Body: ${e.response?.data}");
      }
      throw ApiErrorHandler.handle(e);
    }
  }
}
