// ignore_for_file: constant_identifier_names

import 'package:abo_abed_clothing/screens/auth/login_screen.dart';
import 'package:abo_abed_clothing/screens/auth/create_account_screen.dart';
import 'package:abo_abed_clothing/screens/home/main_admin_home.dart';
import 'package:abo_abed_clothing/screens/home/main_courier_home.dart';
import 'package:abo_abed_clothing/screens/home/main_customer_home.dart';
import 'package:abo_abed_clothing/screens/introduction/intro_screen.dart';
import 'package:abo_abed_clothing/screens/place_holder.dart';
import 'package:abo_abed_clothing/screens/product/product_screen.dart';
import 'package:abo_abed_clothing/routes/role_middleware.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const INTRO = '/intro';
  static const LOGIN = '/login';
  static const PROFILE = '/profile';

  static const HOME = '/home';
  static const MAINHOME = '/main-home';
  static const ADMIN_HOME = '/admin-home';
  static const COURIER_HOME = '/courier-home';
  static const ROLE_REDIRECT = '/role-redirect';
  static const PRODUCT_DETAILS = '/product-details';
  static const CART = '/cart';
  static const PAYMENT_PROOF = '/payment-proof';
  static const CREATE_ACCOUNT = '/create-account';
}

// Import your screen files here

class AppPages {
  static final routes = [
    // Role-based redirect route
    GetPage(
      name: Routes.ROLE_REDIRECT,
      page: () => const LoadingState(),
      middlewares: [RoleMiddleware()],
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const None(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.INTRO,
      page: () => IntroScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const None(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.MAINHOME,
      page: () => const MainCustomerHome(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.ADMIN_HOME,
      page: () => const MainAdminHome(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.COURIER_HOME,
      page: () => const MainCourierHome(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () {
        final productId = Get.parameters['productId'] ?? '';
        return ProductScreen(productId: productId);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.PAYMENT_PROOF,
      page: () => const None(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: Routes.CREATE_ACCOUNT,
      page: () => const CreateAccountScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
