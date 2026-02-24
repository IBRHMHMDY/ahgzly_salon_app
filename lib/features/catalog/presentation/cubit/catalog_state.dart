import 'package:ahgzly_salon_app/features/catalog/domain/entities/branch_entity.dart';
import 'package:ahgzly_salon_app/features/catalog/domain/entities/service_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<BranchEntity> branches;
  final List<ServiceEntity> services;
  final BranchEntity? selectedBranch; // إضافة الفرع المختار

  const CatalogLoaded(this.branches, this.services, {this.selectedBranch});

  @override
  List<Object?> get props => [branches, services, selectedBranch];
}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
   @override
  List<Object?> get props => [message];
}
