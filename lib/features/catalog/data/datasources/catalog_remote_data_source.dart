import 'package:ahgzly_salon_app/core/network/dio_client.dart';
import 'package:ahgzly_salon_app/core/network/error_handler.dart';


class CatalogRemoteDataSource {
  final DioClient dioClient;

  CatalogRemoteDataSource({required this.dioClient});

  Future<List<dynamic>> getBranches() async {
    try {
      final response = await dioClient.dio.get(
        '/catalog/branches',
      );
      return response.data['data'] ??
          response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getServices() async {
    try {
      final response = await dioClient.dio.get(
        '/catalog/services',
      ); 
      return response.data['data'] ?? response.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
