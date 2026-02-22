import 'package:ahgzly_salon_app/features/catalog/domain/entities/branch_entity.dart';
import 'package:ahgzly_salon_app/features/catalog/domain/entities/service_entity.dart';
import 'package:ahgzly_salon_app/features/catalog/domain/usecases/get_catalog_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final GetCatalogUseCase getCatalogUseCase;

  CatalogCubit({required this.getCatalogUseCase}) : super(CatalogInitial());

  Future<void> loadCatalog() async {
    emit(CatalogLoading());
    try {
      final result = await getCatalogUseCase();
      emit(CatalogLoaded(result.$1, result.$2)); // $1 للفروع و $2 للخدمات
    } on Failure catch (failure) {
      emit(CatalogError(failure.message));
    } catch (e) {
      emit(CatalogError("حدث خطأ غير متوقع أثناء جلب البيانات."));
    }
  }
}
