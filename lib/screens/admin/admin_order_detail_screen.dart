import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/order_model.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/global/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const AdminOrderDetailScreen({super.key, required this.order});

  String _statusLabel(String status) {
    final map = {
      'Pending': 'order_status_pending'.tr,
      'Confirmed': 'order_status_confirmed'.tr,
      'PaymentUnderReview': 'order_status_payment_under_review'.tr,
      'Processing': 'order_status_processing'.tr,
      'OnWay': 'order_status_on_way'.tr,
      'Shipped': 'order_status_shipped'.tr,
      'Delivered': 'order_status_delivered'.tr,
      'Cancelled': 'order_status_cancelled'.tr,
    };
    return map[status] ?? status;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Confirmed':
        return Colors.blue;
      case 'PaymentUnderReview':
        return Colors.purple;
      case 'Processing':
        return Colors.teal;
      case 'OnWay':
        return Colors.indigo;
      case 'Shipped':
        return Colors.cyan;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return AppLightTheme.textBody;
    }
  }

  String get _imageBaseUrl => ApiLinks.BASE_URL.replaceAll('/api', '');

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy/MM/dd – HH:mm').format(order.createdAt);
    final statusColor = _statusColor(order.status);

    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          AppSnackbar.showSuccess(message: state.message);
          Navigator.pop(context, true);
        } else if (state is PaymentVerified) {
          AppSnackbar.showSuccess(message: state.message);
          Navigator.pop(context, true);
        } else if (state is OrderFailure) {
          AppSnackbar.showError(message: state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('order_details'.tr, style: TextStyles.titleLarge()),
          centerTitle: true,
          backgroundColor: AppLightTheme.backgroundWhite,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: AppLightTheme.backgroundWhite,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID & Status
              _buildSection(
                children: [
                  _buildRow(
                    'order_number'.tr,
                    '#${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}',
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'status'.tr,
                        style: TextStyles.bodyMedium().copyWith(
                          color: AppLightTheme.silverAccent,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: TextStyles.bodyMedium().copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildRow('order_date'.tr, dateStr),
                  if (order.deliveredAt != null) ...[
                    const SizedBox(height: 8),
                    _buildRow(
                      'confirm_delivery'.tr,
                      DateFormat(
                        'yyyy/MM/dd – HH:mm',
                      ).format(order.deliveredAt!),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // Customer Info
              _buildSectionTitle('customer_info'.tr),
              const SizedBox(height: 8),
              _buildSection(
                children: [
                  _buildRow(
                    'customer_name'.tr,
                    order.customerModel?.name ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildRow(
                    'customer_phone'.tr,
                    order.customerModel?.phone ?? '-',
                  ),
                  const SizedBox(height: 8),
                  _buildRow('address'.tr, order.address ?? 'no_address'.tr),
                ],
              ),
              const SizedBox(height: 16),

              // Order Items
              _buildSectionTitle('${'order_items'.tr} (${order.itemsCount})'),
              const SizedBox(height: 8),
              _buildSection(
                children: [
                  ...order.items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final productName = item.product?.title ?? 'item'.tr;
                    final price =
                        item.priceAtPurchase ?? item.product?.price ?? 0;
                    return Column(
                      children: [
                        if (idx > 0)
                          const Divider(
                            color: AppLightTheme.dividerColor,
                            height: 16,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                productName,
                                style: TextStyles.bodyMedium().copyWith(
                                  color: AppLightTheme.textHeadline,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '×${item.quantity}',
                              style: TextStyles.bodyMedium().copyWith(
                                color: AppLightTheme.silverAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(price * item.quantity).toStringAsFixed(0)} ${'currency'.tr}',
                              style: TextStyles.bodyMedium().copyWith(
                                color: AppLightTheme.goldDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  const Divider(color: AppLightTheme.dividerColor, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total_price'.tr,
                        style: TextStyles.bodyMedium().copyWith(
                          color: AppLightTheme.textHeadline,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${order.totalPrice.toStringAsFixed(0)} ${'currency'.tr}',
                        style: TextStyles.bodyMedium().copyWith(
                          color: AppLightTheme.goldDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Payment Image (if present)
              if (order.paymentImage != null) ...[
                _buildSectionTitle('payment_image'.tr),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showFullImage(context, order.paymentImage!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '$_imageBaseUrl${order.paymentImage}',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: AppLightTheme.surfaceGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: AppLightTheme.silverAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Action Buttons
              _buildActionButtons(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppLightTheme.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppLightTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyles.bodyLarge().copyWith(
        color: AppLightTheme.textHeadline,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.bodyMedium().copyWith(
            color: AppLightTheme.silverAccent,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: TextStyles.bodyMedium().copyWith(
              color: AppLightTheme.textHeadline,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (order.status) {
      case 'Pending':
        return _buildPrimaryButton(
          context,
          label: 'confirm_order'.tr,
          icon: Icons.check_circle_outline,
          color: Colors.blue,
          onPressed: () => _onConfirmOrder(context),
        );
      case 'PaymentUnderReview':
        return Column(
          children: [
            _buildPrimaryButton(
              context,
              label: 'verify_payment'.tr,
              icon: Icons.verified_outlined,
              color: Colors.green,
              onPressed: () => _onVerifyPayment(context),
            ),
            const SizedBox(height: 12),
            _buildPrimaryButton(
              context,
              label: 'reject_payment'.tr,
              icon: Icons.cancel_outlined,
              color: Colors.red,
              onPressed: () => _onRejectPayment(context),
            ),
          ],
        );
      case 'OnWay':
        return _buildPrimaryButton(
          context,
          label: 'confirm_delivery'.tr,
          icon: Icons.local_shipping_outlined,
          color: Colors.green,
          onPressed: () => _onConfirmDelivery(context),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPrimaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final isLoading = state is OrderLoading;
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 20),
            label: Text(
              label,
              style: TextStyles.buttonText.copyWith(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirmOrder(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'confirm_order'.tr,
      content: 'confirm_order_msg'.tr,
      confirmText: 'confirm_order'.tr,
      icon: Icons.check_circle_outline,
      confirmColor: Colors.blue,
    );
    if (confirmed == true && context.mounted) {
      context.read<OrderCubit>().adminConfirmOrder(order.id);
    }
  }

  void _onVerifyPayment(BuildContext context) {
    final courierController = TextEditingController();
    final addressController = TextEditingController(text: order.address);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppLightTheme.backgroundWhite,
          title: Text(
            'verify_payment'.tr,
            style: TextStyles.titleLarge().copyWith(
              color: AppLightTheme.textHeadline,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: courierController,
                decoration: InputDecoration(
                  labelText: 'courier_id'.tr,
                  hintText: 'enter_courier_id'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppLightTheme.goldPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'address_details'.tr,
                  hintText: 'enter_address_details'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppLightTheme.goldPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'cancel'.tr,
                style: TextStyles.bodyMedium().copyWith(
                  color: AppLightTheme.textBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<OrderCubit>().verifyOrderPayment(
                  orderId: order.id,
                  isPaymentValid: true,
                  courierId: courierController.text.trim().isNotEmpty
                      ? courierController.text.trim()
                      : null,
                  addressDetails: addressController.text.trim().isNotEmpty
                      ? addressController.text.trim()
                      : null,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'verify_payment'.tr,
                style: TextStyles.buttonText.copyWith(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onRejectPayment(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'reject_payment'.tr,
      content: 'reject_payment_msg'.tr,
      confirmText: 'reject_payment'.tr,
      icon: Icons.cancel_outlined,
      confirmColor: Colors.red,
    );
    if (confirmed == true && context.mounted) {
      context.read<OrderCubit>().verifyOrderPayment(
        orderId: order.id,
        isPaymentValid: false,
      );
    }
  }

  void _onConfirmDelivery(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'confirm_delivery'.tr,
      content: 'confirm_delivery_msg'.tr,
      confirmText: 'confirm_delivery'.tr,
      icon: Icons.local_shipping_outlined,
      confirmColor: Colors.green,
    );
    if (confirmed == true && context.mounted) {
      context.read<OrderCubit>().confirmDelivery(order.id);
    }
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '$_imageBaseUrl$imagePath',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 300,
                  color: AppLightTheme.surfaceGrey,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: AppLightTheme.silverAccent,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
