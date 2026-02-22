import '../entities/branch_entity.dart';
import '../entities/service_entity.dart';

abstract class CatalogRepository {
  Future<List<BranchEntity>> getBranches();
  Future<List<ServiceEntity>> getServices();
}
