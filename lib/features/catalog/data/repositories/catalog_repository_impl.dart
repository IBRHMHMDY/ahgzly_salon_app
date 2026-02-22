import '../../domain/entities/branch_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_data_source.dart';
import '../models/branch_model.dart';
import '../models/service_model.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  CatalogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BranchEntity>> getBranches() async {
    // جلب البيانات الخام من الـ API
    final remoteBranches = await remoteDataSource.getBranches();

    // تحويل كل عنصر في القائمة من Map (JSON) إلى BranchModel
    return remoteBranches
        .map((branchJson) => BranchModel.fromJson(branchJson))
        .toList();
  }

  @override
  Future<List<ServiceEntity>> getServices() async {
    // جلب البيانات الخام من الـ API
    final remoteServices = await remoteDataSource.getServices();

    // تحويل كل عنصر في القائمة من Map (JSON) إلى ServiceModel
    return remoteServices
        .map((serviceJson) => ServiceModel.fromJson(serviceJson))
        .toList();
  }
}
