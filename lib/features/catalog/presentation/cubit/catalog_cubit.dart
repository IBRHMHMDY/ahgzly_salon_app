import 'package:ahgzly_salon_app/features/catalog/domain/entities/branch_entity.dart';
import 'package:ahgzly_salon_app/features/catalog/domain/entities/service_entity.dart';
import 'package:ahgzly_salon_app/features/catalog/domain/usecases/get_catalog_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final GetCatalogUseCase getCatalogUseCase;

  CatalogCubit({required this.getCatalogUseCase}) : super(CatalogInitial());

  Future<void> loadCatalog() async {
    emit(CatalogLoading());
    final result = await getCatalogUseCase();
    result.fold(
      (failure) => emit(CatalogError(failure.message)),
      (data) => emit(CatalogLoaded(data.$1, data.$2)), // $1 للفروع و $2 للخدمات
    );
  }
}
