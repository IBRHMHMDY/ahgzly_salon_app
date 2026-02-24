import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../entities/branch_entity.dart';
import '../entities/service_entity.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogUseCase {
  final CatalogRepository repository;

  GetCatalogUseCase(this.repository);

  Future<Either<Failure, (List<BranchEntity>, List<ServiceEntity>)>>
  call() async {
    final results = await Future.wait([
      repository.getBranches(),
      repository.getServices(),
    ]);

    final branchesResult = results[0] as Either<Failure, List<BranchEntity>>;
    final servicesResult = results[1] as Either<Failure, List<ServiceEntity>>;

    // دمج النتيجتين: إذا فشل أي منهما نرجع الخطأ، وإذا نجحا نرجع البيانات معاً
    return branchesResult.fold(
      (failure) => Left(failure),
      (branches) => servicesResult.fold(
        (failure) => Left(failure),
        (services) => Right((branches, services)),
      ),
    );
  }
}
