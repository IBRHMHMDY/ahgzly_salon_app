import 'package:ahgzly_salon_app/core/di/injection_container.dart';
import 'package:ahgzly_salon_app/core/routing/routes.dart';
import 'package:ahgzly_salon_app/core/theme/app_colors.dart';
import 'package:ahgzly_salon_app/core/widgets/custom_button.dart';
import 'package:ahgzly_salon_app/core/widgets/app_shimmer.dart';
import 'package:ahgzly_salon_app/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:ahgzly_salon_app/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class BookingPage extends StatelessWidget {
  final int branchId;
  final int serviceId;
  final String serviceName;

  const BookingPage({
    super.key,
    required this.branchId,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<BookingCubit>()
            ..fetchEmployees(
          branchId,
          serviceId,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'حجز: $serviceName',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmployeeSelector(),
            const Divider(),

            // 1. شريط اختيار الأيام
            _buildDaysSelector(),
            const Divider(),

            // 2. شبكة الأوقات المتاحة
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'الأوقات المتاحة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: _buildSlotsGrid()),

            // 3. زر التأكيد
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSelector() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        // توليد قائمة بـ 7 أيام قادمة
        final days = List.generate(
          7,
          (index) => DateTime.now().add(Duration(days: index)),
        );

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isSelected =
                  date.day == cubit.selectedDate.day &&
                  date.month == cubit.selectedDate.month;

              return GestureDetector(
                onTap: () => cubit.selectDate(date, branchId, serviceId),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date), // الشهر
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd').format(date), // اليوم
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSlotsGrid() {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) =>
          current
              is! BookingSubmitLoading, // لا تُعِد بناء الشبكة أثناء التحميل
      builder: (context, state) {
        if (state is BookingSlotsLoading) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 12,
            itemBuilder: (_, _) => const AppShimmer(
              width: double.infinity,
              height: 40,
            ),
          );
        } else if (state is BookingSlotsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        } else if (state is BookingSlotsLoaded) {
          final slots = state.slots;
          if (slots.isEmpty) {
            return const Center(
              child: Text('لا توجد أوقات متاحة في هذا اليوم.'),
            );
          }

          final cubit = context.read<BookingCubit>();
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 أزرار في كل صف
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final isSelected = cubit.selectedSlot == slot;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.primary
                      : (slot.isAvailable
                            ? Colors.white
                            : Colors.grey.shade200),
                  foregroundColor: isSelected
                      ? Colors.white
                      : (slot.isAvailable
                            ? AppColors.textPrimary
                            : Colors.grey),
                  elevation: 0,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (slot.isAvailable
                              ? Colors.grey.shade300
                              : Colors.transparent),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: slot.isAvailable
                    ? () => cubit.selectSlot(slot)
                    : null, // الزر سيكون Disabled تلقائياً
                child: Text(slot.time, style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSubmitSuccess) {
          // عرض رسالة نجاح ثم العودة للشاشة الرئيسية
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم الحجز بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AppointmentsCubit>().fetchAppointments();

          context.goNamed(Routes.myAppointments); // التوجيه
        } else if (state is BookingSubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: CustomButton(
              text: 'تأكيد الحجز',
              isLoading: state is BookingSubmitLoading,
              onPressed: () {
                context.read<BookingCubit>().submitBooking(
                  branchId: branchId,
                  serviceId: serviceId,
                );
              },
            ),
          ),
        );
      },
    );
  }
// دالة التصميم للموظفين
  Widget _buildEmployeeSelector() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        if (cubit.employees.isEmpty) return const SizedBox();

        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: cubit.employees.length,
            itemBuilder: (context, index) {
              final employee = cubit.employees[index];
              final isSelected = cubit.selectedEmployee?.id == employee.id;

              return GestureDetector(
                onTap: () =>
                    cubit.selectEmployee(employee, branchId, serviceId),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    employee.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
