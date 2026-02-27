import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/shipping_helpers.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/shipping_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DeliveryCard extends StatelessWidget {
  final ShippingModel delivery;
  final int index;
  final VoidCallback? onCallCustomer;
  final ValueChanged<String>? onStatusUpdate;

  const DeliveryCard({
    super.key,
    required this.delivery,
    required this.index,
    this.onCallCustomer,
    this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = ShippingHelpers.getStatusColor(delivery.status);
    final dateStr =
        DateFormat('yyyy/MM/dd – HH:mm').format(delivery.createdAt);

    return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppLightTheme.surfaceGrey,
            borderRadius: BorderRadius.circular(12),
            border: const Border.fromBorderSide(
              BorderSide(color: AppLightTheme.dividerColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Tracking # + Status badge ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      delivery.trackingNumber != null
                          ? '#${delivery.trackingNumber}'
                          : '#${delivery.id.length > 8 ? delivery.id.substring(delivery.id.length - 8) : delivery.id}',
                      style: TextStyles.bodyMedium().copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppLightTheme.textHeadline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ShippingHelpers.getStatusLabel(delivery.status),
                      style: TextStyles.bodyMedium().copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Customer Info ──
              if (delivery.customerName.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppLightTheme.silverAccent,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        delivery.customerName,
                        style: TextStyles.bodyMedium().copyWith(
                          color: AppLightTheme.textHeadline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (delivery.customerPhone.isNotEmpty &&
                        onCallCustomer != null)
                      GestureDetector(
                        onTap: onCallCustomer,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
              ],

              // ── Address ──
              if (delivery.addressDetails.isNotEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppLightTheme.silverAccent,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        delivery.addressDetails,
                        style: TextStyles.bodyMedium().copyWith(
                          color: AppLightTheme.textBody,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],

              // ── Order summary row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${delivery.orderTotalPrice.toStringAsFixed(0)} ${'currency'.tr}',
                    style: TextStyles.bodyMedium().copyWith(
                      color: AppLightTheme.goldDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${delivery.orderItemsCount} ${'item'.tr}',
                    style: TextStyles.bodyMedium().copyWith(
                      color: AppLightTheme.silverAccent,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: TextStyles.bodyMedium().copyWith(
                      color: AppLightTheme.silverAccent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              // ── Action buttons ──
              if ((delivery.isPreparing || delivery.isOnWay) &&
                  onStatusUpdate != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppLightTheme.dividerColor),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (delivery.isPreparing)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onStatusUpdate!('OnWay'),
                          icon: const Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: Text(
                            'mark_on_way'.tr,
                            style:
                                TextStyles.buttonText.copyWith(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    if (delivery.isOnWay) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onStatusUpdate!('Delivered'),
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: Text(
                            'mark_delivered'.tr,
                            style:
                                TextStyles.buttonText.copyWith(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onStatusUpdate!('Failed'),
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 18,
                          ),
                          label: Text(
                            'mark_failed'.tr,
                            style: TextStyles.bodyMedium().copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 280.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 280.ms, curve: Curves.easeOut);
  }
}
