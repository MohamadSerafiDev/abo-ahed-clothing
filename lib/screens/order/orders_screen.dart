import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTabData();
    });
  }

  void _loadTabData() {
    if (_selectedTabIndex == 0) {
      context.read<OrderCubit>().getActiveOrders();
    } else {
      context.read<OrderCubit>().getOrdersHistory();
    }
  }

  Future<void> _onRefresh() async {
    _loadTabData();
  }

  String _emptyMessage() {
    return _selectedTabIndex == 0
        ? 'no_orders_found'.tr
        : 'no_order_history_found'.tr;
  }

  String _localizedStatusLabel(String status) {
    switch (status) {
      case 'Pending':
        return 'order_status_pending'.tr;
      case 'Confirmed':
        return 'order_status_confirmed'.tr;
      case 'PaymentUnderReview':
        return 'order_status_payment_under_review'.tr;
      case 'Processing':
        return 'order_status_processing'.tr;
      case 'OnWay':
        return 'order_status_on_way'.tr;
      case 'Delivered':
        return 'order_status_delivered'.tr;
      case 'Cancelled':
        return 'order_status_cancelled'.tr;
      default:
        return status;
    }
  }

  Widget _buildOrderTile(dynamic order, int index) {
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
          Text(
            '#${order.id}',
            style: TextStyles.bodyMedium().copyWith(
              fontWeight: FontWeight.w600,
              color: AppLightTheme.textHeadline,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${'status'.tr}: ${_localizedStatusLabel(order.status)}',
            style: TextStyles.bodyMedium(),
          ),
          const SizedBox(height: 4),
          Text(
            '${'total'.tr}: ${order.totalPrice.toStringAsFixed(2)}',
            style: TextStyles.bodyMedium(),
          ),
          const SizedBox(height: 4),
          Text(
            'items_selected'.trParams({'count': order.itemsCount.toString()}),
            style: TextStyles.bodyMedium(),
          ),
        ],
      ),
    )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 280.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 280.ms, curve: Curves.easeOut);
  }

  Widget _buildOrdersList(List<dynamic> orders) {
    if (orders.isEmpty) {
      return EmptyState(
        message: _emptyMessage(),
        icon: Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildOrderTile(orders[index], index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppLightTheme.backgroundWhite,
        appBar: AppBar(
          title: Text('orders'.tr, style: TextStyles.headlineMedium()),
          centerTitle: true,
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
              _loadTabData();
            },
            indicatorColor: AppLightTheme.goldPrimary,
            labelColor: AppLightTheme.goldPrimary,
            unselectedLabelColor: AppLightTheme.textBody,
            labelStyle: TextStyles.bodyMedium().copyWith(
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: 'active_orders'.tr),
              Tab(text: 'order_history'.tr),
            ],
          ),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            Widget child;

            if (state is OrderLoading) {
              child = const LoadingState(key: ValueKey('orders_loading'));
            } else if (state is OrderFailure) {
              child = ErrorState(
                key: const ValueKey('orders_error'),
                title: 'error'.tr,
                error: state.error,
                onRetry: _loadTabData,
              );
            } else if (state is ActiveOrdersLoaded && _selectedTabIndex == 0) {
              child = KeyedSubtree(
                key: const ValueKey('orders_active'),
                child: _buildOrdersList(state.orders),
              );
            } else if (state is OrderHistoryLoaded && _selectedTabIndex == 1) {
              child = KeyedSubtree(
                key: const ValueKey('orders_history'),
                child: _buildOrdersList(state.orders),
              );
            } else {
              child = const LoadingState(key: ValueKey('orders_idle_loading'));
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
