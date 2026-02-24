import 'package:ahgzly_salon_app/core/network/error_handler.dart';
import 'package:dartz/dartz.dart';

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
  Future<Either<Failure, List<BranchEntity>>> getBranches() async {
    // جلب البيانات الخام من الـ API
    final remoteBranches = await remoteDataSource.getBranches();

    final branches = remoteBranches
        .map<BranchEntity>((branchJson) => BranchModel.fromJson(branchJson))
        .toList();
    return Right(branches);
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices() async {
    try {
      final remoteServices = await remoteDataSource.getServices();
      final services = remoteServices
          .map<ServiceEntity>(
            (serviceJson) => ServiceModel.fromJson(serviceJson),
          )
          .toList();
      return Right(services);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
