part of 'catalog_cubit.dart';


abstract class CatalogState {}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<BranchEntity> branches;
  final List<ServiceEntity> services;
  final BranchEntity? selectedBranch; // إضافة الفرع المختار

  CatalogLoaded(this.branches, this.services, {this.selectedBranch});
}

class CatalogError extends CatalogState {
  final String message;
  CatalogError(this.message);
}
