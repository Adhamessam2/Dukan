import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/sign_up_cubit.dart';
import '../../features/auth/presentation/views/auth_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/views/home_screen.dart';
import 'routes.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => _buildAuthScreen(AuthTab.signIn),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => _buildAuthScreen(AuthTab.signUp),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => BlocProvider<HomeCubit>(
        create: (_) => sl<HomeCubit>()..loadHomeData(),
        child: const HomeScreen(),
      ),
    ),
  ],
);

Widget _buildAuthScreen(AuthTab initialTab) => MultiBlocProvider(
  providers: [
    BlocProvider<LoginCubit>(create: (_) => sl<LoginCubit>()),
    BlocProvider<SignUpCubit>(create: (_) => sl<SignUpCubit>()),
  ],
  child: AuthScreen(initialTab: initialTab),
);
