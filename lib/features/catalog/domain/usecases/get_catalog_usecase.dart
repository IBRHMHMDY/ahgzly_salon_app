import '../entities/branch_entity.dart';
import '../entities/service_entity.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogUseCase {
  final CatalogRepository repository;

  GetCatalogUseCase(this.repository);

  // نستخدم Future.wait لجلب الفروع والخدمات في نفس الوقت (توازي) لتقليل وقت التحميل
  Future<(List<BranchEntity>, List<ServiceEntity>)> call() async {
    final results = await Future.wait([
      repository.getBranches(),
      repository.getServices(),
    ]);

    return (
      results[0] as List<BranchEntity>,
      results[1] as List<ServiceEntity>,
    );
  }
}
