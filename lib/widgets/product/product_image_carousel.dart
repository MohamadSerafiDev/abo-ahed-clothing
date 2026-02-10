import 'dart:async';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.images.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;

      final nextIndex = (_currentIndex + 1) % widget.images.length;

      _controller.animateToItem(
        nextIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );

      setState(() {
        _currentIndex = nextIndex;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    // We define the extent here so we can use it to calculate the index
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double itemExtent = screenWidth * 0.9;

    return Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  // Calculate the current index based on scroll offset
                  // This keeps the dots in sync even during manual swipes
                  final offset = notification.metrics.pixels;
                  final int newIndex = (offset / itemExtent).round();
                  if (newIndex != _currentIndex &&
                      newIndex < widget.images.length) {
                    setState(() {
                      _currentIndex = newIndex;
                    });
                  }
                  return true;
                },
                child: CarouselView(
                  controller: _controller,
                  itemExtent: itemExtent,
                  shrinkExtent: itemExtent * 0.8, // How much side items shrink
                  itemSnapping: true,
                  elevation: 0,
                  backgroundColor: AppLightTheme.surfaceGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  children: widget.images.map((imageUrl) {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print(
                          "Error loading image: $error",
                        ); // Look at your console!
                        return const Center(
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Animated Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppLightTheme.goldPrimary
                        : AppLightTheme.dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        )
        .animate(delay: 500.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }
}
