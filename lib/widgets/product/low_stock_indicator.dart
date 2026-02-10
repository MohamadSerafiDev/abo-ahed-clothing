import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class LowStockIndicator extends StatelessWidget {
  final int stock;

  const LowStockIndicator({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    if (stock >= 4 || stock <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 20,
              )
              .animate(
                delay: 500.ms,
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
                duration: 600.ms,
              )
              .tint(color: Colors.red),
          const SizedBox(width: 8),
          Text(
            'only_x_left_in_stock'.trParams({'count': stock.toString()}),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn().slideX(begin: 0.1, end: 0);
  }
}
