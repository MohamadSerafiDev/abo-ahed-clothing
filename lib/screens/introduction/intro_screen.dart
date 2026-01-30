import 'package:abo_abed_clothing/core/utils/app_images.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Page Decoration for consistent styling
    final pageDecoration = PageDecoration(
      titleTextStyle: context.displayLarge, // Using your custom text_style.dart
      bodyTextStyle: context.bodyLarge,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,

      // 1. Define your slides
      pages: [
        PageViewModel(
          title: "onboarding_title_1".tr, // "Welcome to Abu Ahed"
          body: "onboarding_body_1".tr, // "Exclusive collections..."
          image: Image.asset(AppImages.IntroOne, width: 350),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "onboarding_title_2".tr, // "New & Used"
          body: "onboarding_body_2".tr, // "Give premium clothes a second life."
          image: Image.asset(AppImages.IntroTwo, width: 350),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "onboarding_title_3".tr, // "Easy Payment"
          body: "onboarding_body_3".tr, // "Bank transfer & fast verification."
          image: Image.asset(AppImages.IntroThree, width: 350),
          decoration: pageDecoration,
        ),
      ],

      // 2. Navigation Buttons
      onDone: () => Get.offAllNamed(Routes.LOGIN),
      onSkip: () => Get.offAllNamed(Routes.LOGIN),
      showSkipButton: true,

      // 3. Labels (Translated)
      skip: Text(
        "skip".tr,
        style: TextStyle(color: context.theme.primaryColor),
      ),
      next: const Icon(Icons.arrow_forward),
      done: Text(
        "done".tr,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),

      // 4. Dot Styling (Using your Gold color)
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: AppLightTheme.silverAccent,
        activeColor: AppLightTheme.goldPrimary,
        activeSize: const Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
