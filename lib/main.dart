import 'dart:developer';

import 'package:abo_abed_clothing/blocs/cart/cart_cubit.dart';
import 'package:abo_abed_clothing/blocs/login/auth_cubit.dart';
import 'package:abo_abed_clothing/blocs/notification/notification_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/product/product_cubit.dart';
import 'package:abo_abed_clothing/blocs/shipping/shipping_cubit.dart';
import 'package:abo_abed_clothing/core/apis/cart/cart_api.dart';
import 'package:abo_abed_clothing/core/apis/notification/notification_api.dart';
import 'package:abo_abed_clothing/core/apis/order/order_api.dart';
import 'package:abo_abed_clothing/core/apis/product/product_api.dart';
import 'package:abo_abed_clothing/core/apis/shipping/shipping_api.dart';
import 'package:abo_abed_clothing/core/apis/user/user_api.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:abo_abed_clothing/core/localization/app_translations.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';
import 'package:abo_abed_clothing/routes/role_middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storageService = await StorageService().init();
  Get.put(storageService);
  // Initialize API service
  final apiService = ApiService(
    storage: storageService,
    onUnauthorized: (statusCode) async {
      await storageService.logout();
      Get.offAllNamed(Routes.LOGIN);
    },
  );

  // Initialize services
  final userApi = UserApi(apiService);
  final productService = ProductApi(apiService);
  final cartService = CartApi(apiService);
  final orderService = OrderApi(apiService);
  final shippingService = ShippingApi(apiService);
  final notificationService = NotificationApi(apiService);

  runApp(
    MainApp(
      storageService: storageService,
      userApi: userApi,
      productService: productService,
      cartService: cartService,
      orderService: orderService,
      shippingService: shippingService,
      notificationService: notificationService,
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
    required this.storageService,
    required this.userApi,
    required this.productService,
    required this.cartService,
    required this.orderService,
    required this.shippingService,
    required this.notificationService,
  });
  final StorageService storageService;
  final UserApi userApi;
  final ProductApi productService;
  final CartApi cartService;
  final OrderApi orderService;
  final ShippingApi shippingService;
  final NotificationApi notificationService;
  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    log(storage.isFirstTime().toString(), name: 'is first time');

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: productService),
        RepositoryProvider.value(value: cartService),
        RepositoryProvider.value(value: orderService),
        RepositoryProvider.value(value: shippingService),
        RepositoryProvider.value(value: notificationService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(userApi, storageService)),
          BlocProvider(create: (context) => ProductCubit(productService)),
          BlocProvider(create: (context) => CartCubit(cartService)),
          BlocProvider(create: (context) => OrderCubit(orderService)),
          BlocProvider(create: (context) => ShippingCubit(shippingService)),
          BlocProvider(
            create: (context) => NotificationCubit(notificationService),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          translations: AppTranslations(),
          locale: const Locale('ar', 'SA'),
          fallbackLocale: const Locale('en', 'US'),
          // Routing
          initialRoute: storage.isFirstTime()
              ? Routes.INTRO
              : storage.isLoggedIn()
              ? getHomeRouteForRole(storage)
              : Routes.LOGIN,
          getPages: AppPages.routes,
        ),
      ),
    );
  }
}
