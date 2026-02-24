import 'package:ahgzly_salon_app/features/appointments/domain/entities/appointment_entity.dart';
import 'package:ahgzly_salon_app/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_shimmer.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentsCubit>().fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حجوزاتي'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'مكتمل'),
              Tab(text: 'مؤكد'),
              Tab(text: 'ملغي'),
              // Tab(text: 'الكل'),
            ],
          ),
        ),
        body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading) {
              return _buildLoadingShimmer();
            } else if (state is AppointmentsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            } else if (state is AppointmentsLoaded) {
              return TabBarView(
                children: [
                 _buildAppointmentsList(
                    state.appointments
                        .where((a) => a.status == 'pending')
                        .toList(),
                  ), // قيد الانتظار
                  _buildAppointmentsList(
                    state.appointments
                        .where((a) => a.status == 'completed')
                        .toList(),
                  ), // مكتمل
                  _buildAppointmentsList(
                    state.appointments
                        .where((a) => a.status == 'confirmed')
                        .toList(),
                  ), // مؤكد
                  
                  _buildAppointmentsList(
                    state.appointments
                        .where((a) => a.status == 'cancelled')
                        .toList(),
                  ), // ملغي
                  //  _buildAppointmentsList(state.appointments), // الكل
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // دالة موحدة لبناء القائمة لكل تاب لتجنب تكرار الكود
  Widget _buildAppointmentsList(List<AppointmentEntity> appointments) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text('لا توجد حجوزات.', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _AppointmentCard(appointment: appointments[index]);
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: AppShimmer(
          width: double.infinity,
          height: 120,
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appointment.serviceName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusBadge(appointment.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  appointment.branchName,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.date,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment.startTime,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (appointment.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  // زر التأكيد
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context
                          .read<AppointmentsCubit>()
                          .updateStatus(appointment.id, 'confirmed'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                      ),
                      child: const Text('تأكيد'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // زر الإلغاء
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context
                          .read<AppointmentsCubit>()
                          .updateStatus(appointment.id, 'cancelled'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        text = 'مكتمل';
        break;
      case 'confirmed':
        color = const Color.fromARGB(255, 30, 169, 176);
        text = 'مؤكد';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'ملغي';
        break;
      default:
        color = Colors.orange;
        text = 'قيد الانتظار';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
