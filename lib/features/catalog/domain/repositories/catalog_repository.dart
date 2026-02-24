import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

import '../entities/branch_entity.dart';
import '../entities/service_entity.dart';

abstract class CatalogRepository {
  Future<Either<Failure,List<BranchEntity>>> getBranches();
  Future<Either<Failure,List<ServiceEntity>>> getServices();
}
