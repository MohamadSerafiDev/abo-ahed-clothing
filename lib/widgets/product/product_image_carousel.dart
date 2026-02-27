import 'dart:async';
import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';

enum CarouselMediaType { image, video }

class CarouselMediaItem {
  final String url;
  final CarouselMediaType type;

  const CarouselMediaItem({required this.url, required this.type});
}

class ProductImageCarousel extends StatefulWidget {
  final List<CarouselMediaItem> media;

  const ProductImageCarousel({super.key, required this.media});

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
    if (widget.media.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;

      final nextIndex = (_currentIndex + 1) % widget.media.length;

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

  String _resolveUrl(String rawUrl) {
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }
    return ApiLinks.BASE_URL.replaceAll('/api', '') + rawUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) return const SizedBox.shrink();

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
                      newIndex >= 0 &&
                      newIndex < widget.media.length) {
                    setState(() {
                      _currentIndex = newIndex;
                    });
                  }
                  return false;
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
                  children: List.generate(widget.media.length, (index) {
                    final item = widget.media[index];
                    final mediaUrl = _resolveUrl(item.url);

                    if (item.type == CarouselMediaType.video) {
                      return _CarouselVideoItem(
                        videoUrl: mediaUrl,
                        isActive: _currentIndex == index,
                      );
                    }

                    return Image.network(
                      mediaUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading image: $error');
                        return const Center(
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Animated Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.media.length,
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

class _CarouselVideoItem extends StatefulWidget {
  final String videoUrl;
  final bool isActive;

  const _CarouselVideoItem({required this.videoUrl, required this.isActive});

  @override
  State<_CarouselVideoItem> createState() => _CarouselVideoItemState();
}

class _CarouselVideoItemState extends State<_CarouselVideoItem> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      controller.addListener(() {
        if (!mounted) return;
        if (controller.value.hasError && !_hasError) {
          setState(() {
            _hasError = true;
            _errorMessage = controller.value.errorDescription;
          });
        }
      });

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      _videoController = controller;
      _isInitialized = true;

      if (widget.isActive) {
        await controller.play();
      }

      setState(() {});
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = error.toString();
      });
      debugPrint('Video init failed for ${widget.videoUrl}: $error');
    }
  }

  @override
  void didUpdateWidget(covariant _CarouselVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = _videoController;
    if (!_isInitialized || _hasError || controller == null) return;
    try {
      if (widget.isActive) {
        controller.play();
      } else {
        controller.pause();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off, color: Colors.grey, size: 36),
            const SizedBox(height: 8),
            Text(
              'Failed to load video',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            if (_errorMessage != null && _errorMessage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _errorMessage!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    final controller = _videoController;
    if (!_isInitialized || controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }
}
