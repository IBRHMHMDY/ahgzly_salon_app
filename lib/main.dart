import 'package:ahgzly_salon_app/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:ahgzly_salon_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ahgzly_salon_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const AhgzlyApp());
}

class AhgzlyApp extends StatelessWidget {
  const AhgzlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (_) => di.sl<CatalogCubit>()..loadCatalog()),
        BlocProvider(create: (_) => di.sl<AppointmentsCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Ahgzly Salon',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
