import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/network_info.dart';
import '../utils/constants.dart';
import '../api/api_interceptors.dart';
import '../api/api_consumer.dart';
import '../api/dio_consumer.dart';
import '../cache/cache.dart';
import '../cache/secure_storage.dart';
import '../config/app_config.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/sign_up_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_categories_use_case.dart';
import '../../features/home/domain/usecases/get_category_by_id_use_case.dart';
import '../../features/home/domain/usecases/get_products_use_case.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/product_details/data/datasources/product_details_remote_data_source.dart';
import '../../features/product_details/data/repositories/product_details_repository_impl.dart';
import '../../features/product_details/domain/repositories/product_details_repository.dart';
import '../../features/product_details/domain/usecases/get_product_by_id_use_case.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_use_case.dart';
import '../../features/cart/domain/usecases/clear_cart_use_case.dart';
import '../../features/cart/domain/usecases/delete_cart_item_use_case.dart';
import '../../features/cart/domain/usecases/get_cart_item_use_case.dart';
import '../../features/cart/domain/usecases/get_cart_use_case.dart';
import '../../features/cart/domain/usecases/update_cart_item_use_case.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/create_order_use_case.dart';
import '../../features/orders/domain/usecases/get_orders_use_case.dart';
import '../../features/orders/domain/usecases/get_order_by_id_use_case.dart';
import '../../features/orders/domain/usecases/get_order_payment_status_use_case.dart';
import '../../features/orders/domain/usecases/cancel_order_use_case.dart';
import '../../features/orders/presentation/cubit/checkout_cubit.dart';
import '../../features/orders/presentation/cubit/order_details_cubit.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

final sl = GetIt.instance;

/// Initialize Dependency Injection
Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );
  sl.registerLazySingleton<InternetConnection>(
    () => InternetConnection.createInstance(),
  );

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        getToken: () => sl<SecureStorageService>().getAuthToken(),
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        enabled: AppConfig.enableLogging,
      ),
    );

    return dio;
  });

  //! Core Services
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl(sl()));
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(storage: sl()),
  );

  //! Features - Auth
  sl.registerFactory<SignUpCubit>(() => SignUpCubit(signUpUseCase: sl()));
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(loginUseCase: sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      secureStorageService: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl()),
  );

  //! Features - Home
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(getCategoriesUseCase: sl(), getProductsUseCase: sl()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );
  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton<GetCategoryByIdUseCase>(
    () => GetCategoryByIdUseCase(sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiConsumer: sl()),
  );

  //! Features - Product Details
  sl.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getProductByIdUseCase: sl()),
  );
  sl.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(sl()),
  );
  sl.registerLazySingleton<ProductDetailsRepository>(
    () =>
        ProductDetailsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(apiConsumer: sl()),
  );

  //! Features - Cart
  sl.registerFactory<CartCubit>(
    () => CartCubit(
      addToCartUseCase: sl(),
      getCartUseCase: sl(),
      getCartItemUseCase: sl(),
      updateCartItemUseCase: sl(),
      deleteCartItemUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<AddToCartUseCase>(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton<GetCartUseCase>(() => GetCartUseCase(sl()));
  sl.registerLazySingleton<GetCartItemUseCase>(() => GetCartItemUseCase(sl()));
  sl.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteCartItemUseCase>(
    () => DeleteCartItemUseCase(sl()),
  );
  sl.registerLazySingleton<ClearCartUseCase>(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(apiConsumer: sl()),
  );

  //! Features - Orders
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(createOrderUseCase: sl()),
  );
  sl.registerFactory<OrdersCubit>(
    () => OrdersCubit(getOrdersUseCase: sl(), cancelOrderUseCase: sl()),
  );
  sl.registerFactory<OrderDetailsCubit>(
    () => OrderDetailsCubit(
      getOrderByIdUseCase: sl(),
      getOrderPaymentStatusUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<CreateOrderUseCase>(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton<GetOrdersUseCase>(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton<GetOrderByIdUseCase>(
    () => GetOrderByIdUseCase(sl()),
  );
  sl.registerLazySingleton<GetOrderPaymentStatusUseCase>(
    () => GetOrderPaymentStatusUseCase(sl()),
  );
  sl.registerLazySingleton<CancelOrderUseCase>(() => CancelOrderUseCase(sl()));
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
