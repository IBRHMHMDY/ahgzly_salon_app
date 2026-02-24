import 'package:ahgzly_salon_app/core/routing/routes.dart';
import 'package:ahgzly_salon_app/core/theme/app_colors.dart';
import 'package:ahgzly_salon_app/core/widgets/app_shimmer.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(
                  height: 110, // ارتفاع ثابت لقائمة الفروع الأفقية
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // 🟢 سر العرض الأفقي
                    itemCount: state.branches.length,
                    itemBuilder: (context, index) {
                      final branch = state.branches[index];
                      final isSelected = state.selectedBranch?.id == branch.id;

                      return Padding(
                        // مسافة بين الكروت (للغة العربية من اليمين لليسار نستخدم left)
                        padding: const EdgeInsets.only(left: 12.0),
                        child: InkWell(
                          onTap: () {
                            context.read<CatalogCubit>().selectBranch(branch);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 200, // عرض الكارت
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.08)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              // إضافة ظل خفيف للكروت غير المختارة
                              boxShadow: [
                                if (!isSelected)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.storefront_rounded,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade500,
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  branch.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  branch.address,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // 🟢 الشرط الجديد: إخفاء الخدمات إذا لم يتم اختيار فرع
                if (state.selectedBranch == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'يرجى اختيار فرع أولاً لعرض الخدمات المتاحة',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  )
                else ...[
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
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
                        onTap: () {
                          if (state.selectedBranch != null) {
                            final branchId = state.selectedBranch!.id;
                            final serviceId = service.id;
                            context.push(
                              Routes.booking,
                              extra: {
                                'branchId': branchId,
                                'serviceId': serviceId,
                                'serviceName': service.name,
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
          return const SizedBox(); // الحالة الابتدائية
        },
      ),
    );
  }

  // واجهة الـ Shimmer لتعطي تجربة مستخدم ممتازة أثناء التحميل
  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const AppShimmer(width: 150, height: 24), // عنوان الفروع
        const SizedBox(height: 12),
        ...List.generate(
          2,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: AppShimmer(width: double.infinity, height: 80), // كارت الفرع
          ),
        ),
        const SizedBox(height: 32),
        const AppShimmer(width: 150, height: 24), // عنوان الخدمات
        const SizedBox(height: 12),
        ...List.generate(
          4,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: AppShimmer(
              width: double.infinity,
              height: 80,
            ), // كارت الخدمة
          ),
        ),
      ],
    );
  }
}
