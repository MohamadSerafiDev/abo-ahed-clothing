import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Widget _buildOrderTile(dynamic order) {
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
          Text('${'status'.tr}: ${order.status}', style: TextStyles.bodyMedium()),
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
    );
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
        itemBuilder: (context, index) => _buildOrderTile(orders[index]),
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
            if (state is OrderLoading) {
              return const LoadingState();
            }

            if (state is OrderFailure) {
              return ErrorState(
                title: 'error'.tr,
                error: state.error,
                onRetry: _loadTabData,
              );
            }

            if (state is ActiveOrdersLoaded && _selectedTabIndex == 0) {
              return _buildOrdersList(state.orders);
            }

            if (state is OrderHistoryLoaded && _selectedTabIndex == 1) {
              return _buildOrdersList(state.orders);
            }

            return const LoadingState();
          },
        ),
      ),
    );
  }
}
