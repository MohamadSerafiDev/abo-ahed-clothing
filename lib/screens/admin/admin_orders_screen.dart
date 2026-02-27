import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/order_model.dart';
import 'package:abo_abed_clothing/screens/admin/admin_order_detail_screen.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String? _selectedStatus;
  List<OrderModel> _allOrders = [];
  bool _isLoading = true;
  String? _error;

  static const List<String> _statuses = [
    'Pending',
    'Confirmed',
    'PaymentUnderReview',
    'Processing',
    'OnWay',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getAllOrdersAdmin();
  }

  List<OrderModel> get _filteredOrders {
    if (_selectedStatus == null) return _allOrders;
    return _allOrders.where((o) => o.status == _selectedStatus).toList();
  }

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

  int _statusCount(String status) {
    return _allOrders.where((o) => o.status == status).length;
  }

  Future<void> _refresh() async {
    context.read<OrderCubit>().getAllOrdersAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('all_orders'.tr, style: TextStyles.titleLarge()),
        centerTitle: true,
        backgroundColor: AppLightTheme.backgroundWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: AppLightTheme.backgroundWhite,
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is AdminAllOrdersLoaded) {
            setState(() {
              _allOrders = state.orders;
              _isLoading = false;
              _error = null;
            });
          } else if (state is OrderFailure) {
            setState(() {
              _isLoading = false;
              _error = state.error;
            });
            AppSnackbar.showError(message: state.error);
          } else if (state is OrderLoading) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          } else if (state is OrderSuccess || state is PaymentVerified) {
            // An admin action succeeded — refresh the list
            context.read<OrderCubit>().getAllOrdersAdmin();
          }
        },
        builder: (context, state) {
          if (_isLoading && _allOrders.isEmpty) {
            return const LoadingState();
          }

          if (_error != null && _allOrders.isEmpty) {
            return ErrorState(error: _error!, onRetry: _refresh);
          }

          return Column(
            children: [
              // Status filter chips
              _buildStatusChips(),
              const Divider(height: 1, color: AppLightTheme.dividerColor),
              // Orders list
              Expanded(
                child: RefreshIndicator(
                  color: AppLightTheme.goldPrimary,
                  onRefresh: _refresh,
                  child: _filteredOrders.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: EmptyState(
                                message: 'no_orders_found'.tr,
                                icon: Icons.receipt_long_outlined,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: _filteredOrders.length,
                          itemBuilder: (context, index) {
                            return _buildOrderTile(_filteredOrders[index]);
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // "All" chip
          _buildChip(
            label: '${'all_statuses'.tr} (${_allOrders.length})',
            isSelected: _selectedStatus == null,
            onTap: () => setState(() => _selectedStatus = null),
          ),
          const SizedBox(width: 8),
          ..._statuses.map((status) {
            final count = _statusCount(status);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
                label: '${_statusLabel(status)} ($count)',
                isSelected: _selectedStatus == status,
                color: _statusColor(status),
                onTap: () {
                  setState(() {
                    _selectedStatus =
                        _selectedStatus == status ? null : status;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    Color? color,
    required VoidCallback onTap,
  }) {
    final chipColor = color ?? AppLightTheme.goldPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : AppLightTheme.surfaceGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : AppLightTheme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.bodyMedium().copyWith(
            color: isSelected ? Colors.white : AppLightTheme.textBody,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTile(OrderModel order) {
    final customerName =
        order.customerModel?.name ?? 'customer_name'.tr;
    final dateStr = DateFormat('yyyy/MM/dd – HH:mm').format(order.createdAt);
    final statusColor = _statusColor(order.status);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<OrderCubit>(),
              child: AdminOrderDetailScreen(order: order),
            ),
          ),
        );
        if (result == true) {
          _refresh();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppLightTheme.surfaceGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppLightTheme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: order ID + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '#${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}',
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
                    _statusLabel(order.status),
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
            // Customer name
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
                    customerName,
                    style: TextStyles.bodyMedium().copyWith(
                      color: AppLightTheme.textBody,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Bottom row: price + date + items count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.totalPrice.toStringAsFixed(0)} ${'currency'.tr}',
                  style: TextStyles.bodyMedium().copyWith(
                    color: AppLightTheme.goldDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${order.itemsCount} ${'item'.tr}',
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
          ],
        ),
      ),
    );
  }
}
