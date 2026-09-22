import 'package:Dukan/features/cart/presentation/views/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/sign_up_cubit.dart';
import '../../features/auth/presentation/views/auth_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/home/domain/entities/product_entity.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../features/product_details/presentation/views/product_details_screen.dart';
import '../../features/cart/domain/entities/cart_entity.dart';
import '../../features/orders/presentation/cubit/checkout_cubit.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/presentation/views/checkout_screen.dart';
import '../../features/orders/presentation/views/orders_screen.dart';
import '../../features/orders/presentation/cubit/order_details_cubit.dart';
import '../../features/orders/presentation/views/order_details_screen.dart';
import 'package:Dukan/features/orders/presentation/views/payment_webview_args.dart';
import 'package:Dukan/features/orders/presentation/views/payment_webview_screen.dart';
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
    ShellRoute(
      builder: (context, state, child) => BlocProvider<CartCubit>(
        create: (_) => sl<CartCubit>()..getCart(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => BlocProvider<HomeCubit>(
            create: (_) => sl<HomeCubit>()..loadHomeData(),
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: Routes.productDetails,
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            final initialProduct = state.extra as ProductEntity?;
            return BlocProvider<ProductDetailsCubit>(
              create: (_) =>
                  sl<ProductDetailsCubit>()
                    ..loadProductDetails(id, initialProduct: initialProduct),
              child: const ProductDetailsScreen(),
            );
          },
        ),
        GoRoute(
          path: Routes.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: Routes.checkout,
          builder: (context, state) {
            final cart = state.extra as CartEntity?;
            return BlocProvider<CheckoutCubit>(
              create: (_) => sl<CheckoutCubit>(),
              child: CheckoutScreen(cart: cart),
            );
          },
        ),
        GoRoute(
          path: Routes.orders,
          builder: (context, state) => BlocProvider<OrdersCubit>(
            create: (_) => sl<OrdersCubit>()..loadOrders(),
            child: const OrdersScreen(),
          ),
        ),
        GoRoute(
          path: Routes.orderDetails,
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return BlocProvider<OrderDetailsCubit>(
              create: (_) => sl<OrderDetailsCubit>()..loadOrderDetails(id),
              child: OrderDetailsScreen(orderId: id),
            );
          },
        ),
        GoRoute(
          path: Routes.paymentWebView,
          builder: (context, state) {
            final args = state.extra as PaymentWebViewArgs?;
            if (args == null) {
              return BlocProvider<OrdersCubit>(
                create: (_) => sl<OrdersCubit>()..loadOrders(),
                child: const OrdersScreen(),
              );
            }
            return PaymentWebViewScreen(args: args);
          },
        ),
      ],
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
