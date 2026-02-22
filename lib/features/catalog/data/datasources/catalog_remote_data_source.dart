import '../../../../core/network/dio_client.dart';
import '../../../../core/error/api_error_handler.dart';

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
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<List<dynamic>> getServices() async {
    try {
      final response = await dioClient.dio.get(
        '/catalog/services',
      ); 
      return response.data['data'] ?? response.data;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
