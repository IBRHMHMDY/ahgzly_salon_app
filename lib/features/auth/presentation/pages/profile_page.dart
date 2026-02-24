import 'package:ahgzly_salon_app/core/routing/routes.dart';
import 'package:ahgzly_salon_app/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.push(Routes.editProfile, extra: state.user);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      // استخدمنا BlocConsumer للاستماع لحالة Unauthenticated والتوجيه
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.go(Routes.login); // طرد المستخدم فور تسجيل الخروج
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is Authenticated) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildProfileItem(Icons.person_outline, 'الاسم', user.name),
                  const Divider(),
                  _buildProfileItem(Icons.email_outlined, 'البريد', user.email),
                  const Divider(),
                  _buildProfileItem(Icons.phone_outlined, 'الهاتف', user.phone),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // 1. تصفير بيانات المستخدم الحالي من الذاكرة (RAM) لمنع تسريبها
                        context.read<AppointmentsCubit>().reset();

                        // 2. مسح التوكن من الذاكرة المحلية واستدعاء API تسجيل الخروج
                        context.read<AuthCubit>().logout();

                        // 3. التوجيه الإجباري لشاشة الدخول ومسح مسار الشاشات السابقة
                        context.go(Routes.login);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // حالة استثنائية إذا لم يتم تحميل البيانات
          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<AuthCubit>().getProfile(),
              child: const Text('إعادة تحميل البيانات'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
