import 'package:ahgzly_salon_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CatalogCubit>()..loadCatalog(),
      child: Scaffold(
        appBar: AppBar(title: const Text('احجزلي - الفروع والخدمات')),
        body: BlocBuilder<CatalogCubit, CatalogState>(
          builder: (context, state) {
            if (state is CatalogLoading) {
              return _buildShimmerLoading();
            } else if (state is CatalogError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is CatalogLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'الفروع المتاحة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...state.branches.map(
                    (branch) => Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          branch.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          branch.address,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.storefront_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'الخدمات المتاحة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...state.services.map(
                    (service) => Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          service.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'المدة: ${service.durationMinutes} دقيقة',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: Text(
                          '${service.price} ج.م',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox(); // الحالة الابتدائية
          },
        ),
      ),
    );
  }

  // واجهة الـ Shimmer لتعطي تجربة مستخدم ممتازة أثناء التحميل
  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CustomShimmer(width: 150, height: 24), // عنوان الفروع
        const SizedBox(height: 12),
        ...List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: CustomShimmer(
              width: double.infinity,
              height: 80,
              borderRadius: 12,
            ), // كارت الفرع
          ),
        ),
        const SizedBox(height: 32),
        const CustomShimmer(width: 150, height: 24), // عنوان الخدمات
        const SizedBox(height: 12),
        ...List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: CustomShimmer(
              width: double.infinity,
              height: 80,
              borderRadius: 12,
            ), // كارت الخدمة
          ),
        ),
      ],
    );
  }
}
