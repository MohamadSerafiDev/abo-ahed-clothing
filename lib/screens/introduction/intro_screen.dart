import 'package:abo_abed_clothing/core/storage_service.dart';
import 'package:abo_abed_clothing/core/utils/app_images.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "onboarding_title_1", //تشكيلات رائعة
      "body":
          "onboarding_body_1", // اكتشف مجموعة واسعة من الملابس الجديدة و المستعملة
      "image": AppImages.IntroOne,
    },
    {
      "title": "onboarding_title_2", // تجربة سلسة
      "body": "onboarding_body_2", // من التحويلات المالية الامنة للتوصيل السريع
      "image": AppImages.IntroTwo,
    },
    {
      "title": "onboarding_title_3",
      "body": "onboarding_body_3",
      "image": AppImages.IntroThree,
    },
  ];

  void _onNext() async {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await Get.find<StorageService>().setFirstTime(false);
      Get.offAllNamed(Routes.CREATE_ACCOUNT);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Image.asset(
                    _pages[index]['image']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  )
                  .animate(key: ValueKey('img_$index'))
                  .scale(
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1.0, 1.0),
                    duration: 1200.ms,
                    curve: Curves.easeOut,
                  );
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                          _pages[_currentIndex]['title']!.tr,
                          style: context.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .animate(key: ValueKey('title_$_currentIndex'))
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 10),
                    Text(
                          _pages[_currentIndex]['body']!.tr,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        )
                        .animate(key: ValueKey('body_$_currentIndex'))
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentIndex == index
                              ? 24
                              : 8, // Expand active dot
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? const Color(0xFFD4AF37)
                                : Colors.white30,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 40),

                    Center(
                          child: GestureDetector(
                            onTap: _onNext,
                            child: Container(
                              width: 300,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppLightTheme.goldPrimary,
                                // shape: BoxShape.circle,
                                borderRadius: .circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppLightTheme.goldPrimary
                                        .withOpacity(0.4),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: .center,
                                spacing: 8,
                                children: [
                                  Text(
                                    _currentIndex != _pages.length - 1
                                        ? 'next'.tr
                                        : 'get_started'.tr,
                                    style: context.titleLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    _currentIndex == _pages.length - 1
                                        ? Icons.check
                                        : Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate(
                          target: _currentIndex == _pages.length - 1 ? 1 : 0,
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .shimmer(
                          duration: 2000.ms,
                          color: const Color.fromARGB(119, 255, 255, 255),
                        )
                        .scale(
                          begin: const Offset(.95, .95),
                          end: const Offset(1.05, 1.05),
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
