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
      (data) {
        final branches = data.$1;
        final services = data.$2;
      final defaultBranch = branches.isNotEmpty ? branches.first : null;
      emit(
        CatalogLoaded(
          branches,
          services,
          selectedBranch: defaultBranch, // تمرير الفرع الافتراضي للحالة
        ),
      );
      } 
    );
  }

  void selectBranch(BranchEntity branch) {
    if (state is CatalogLoaded) {
      final currentState = state as CatalogLoaded;

      // ملاحظة: إذا أضفت branch_id مستقبلاً للخدمات، يمكنك فلترتها هنا هكذا:
      // final filteredServices = currentState.services.where((s) => s.branchId == branch.id).toList();

      emit(
        CatalogLoaded(
          currentState.branches,
          currentState.services,
          selectedBranch: branch, // تحديث الفرع المختار
        ),
      );
    }
  }
}
