import 'package:abo_abed_clothing/screens/auth/create_account_screen.dart';
import 'package:abo_abed_clothing/screens/introduction/intro_screen.dart';
import 'package:abo_abed_clothing/screens/none.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const INTRO = '/intro';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const PRODUCT_DETAILS = '/product-details';
  static const CART = '/cart';
  static const PAYMENT_PROOF = '/payment-proof';
  static const CREATE_ACCOUNT = '/create-account';
}

// Import your screen files here

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () => const None(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: Routes.PAYMENT_PROOF,
      page: () => const None(),
      transition: Transition.downToUp, // Good for a "modal" feel
    ),
    GetPage(
      name: Routes.CREATE_ACCOUNT,
      page: () => const CreateAccountScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
