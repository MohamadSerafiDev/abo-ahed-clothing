import 'dart:developer';
import 'dart:io';

import 'package:abo_abed_clothing/blocs/order/order_cubit.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/order_helpers.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/order_model.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/order/status_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _activeFilter;
  String? _historyFilter;

  List<OrderModel> _activeOrders = [];
  List<OrderModel> _historyOrders = [];
  bool _isLoading = true;
  String? _error;

  final ImagePicker _imagePicker = ImagePicker();

  static const List<String> _activeStatuses = [
    'Pending',
    'Confirmed',
    'PaymentUnderReview',
    'Processing',
    'OnWay',
  ];

  static const List<String> _historyStatuses = ['Delivered', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadTabData();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTabData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTabData() {
    if (_tabController.index == 0) {
      context.read<OrderCubit>().getActiveOrders();
    } else {
      context.read<OrderCubit>().getOrdersHistory();
    }
  }

  Future<void> _onRefresh() async {
    _loadTabData();
  }

  List<OrderModel> get _filteredActiveOrders {
    if (_activeFilter == null) return _activeOrders;
    return _activeOrders.where((o) => o.status == _activeFilter).toList();
  }

  List<OrderModel> get _filteredHistoryOrders {
    if (_historyFilter == null) return _historyOrders;
    return _historyOrders.where((o) => o.status == _historyFilter).toList();
  }

  int _statusCount(String status, List<OrderModel> orders) {
    return orders.where((o) => o.status == status).length;
  }

  // ── Upload payment image ──
  Future<void> _pickAndUploadPayment(OrderModel order) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('choose_image_source'.tr, style: TextStyles.titleLarge()),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppLightTheme.goldPrimary,
                ),
                title: Text('gallery'.tr),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppLightTheme.goldPrimary,
                ),
                title: Text('camera'.tr),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();
    if (!mounted) return;

    context.read<OrderCubit>().uploadPaymentImage(
      orderId: order.id,
      imageBytes: bytes,
      fileName: picked.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('orders'.tr, style: TextStyles.headlineMedium()),
        centerTitle: true,
        backgroundColor: AppLightTheme.backgroundWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
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
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is ActiveOrdersLoaded) {
            setState(() {
              _activeOrders = state.orders;
              _isLoading = false;
              _error = null;
            });
          } else if (state is OrderHistoryLoaded) {
            setState(() {
              _historyOrders = state.orders;
              _isLoading = false;
              _error = null;
            });
          } else if (state is OrderLoading) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          } else if (state is OrderFailure) {
            setState(() {
              _isLoading = false;
              _error = state.error;
            });
            log(state.error, name: 'order screen error');
            AppSnackbar.showError(message: state.error);
          } else if (state is OrderSuccess) {
            AppSnackbar.showSuccess(message: state.message);
            _loadTabData();
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTabContent(
                orders: _activeOrders,
                filteredOrders: _filteredActiveOrders,
                statuses: _activeStatuses,
                selectedFilter: _activeFilter,
                onFilterChanged: (s) => setState(() => _activeFilter = s),
                emptyMsg: 'no_orders_found'.tr,
              ),
              _buildTabContent(
                orders: _historyOrders,
                filteredOrders: _filteredHistoryOrders,
                statuses: _historyStatuses,
                selectedFilter: _historyFilter,
                onFilterChanged: (s) => setState(() => _historyFilter = s),
                emptyMsg: 'no_order_history_found'.tr,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent({
    required List<OrderModel> orders,
    required List<OrderModel> filteredOrders,
    required List<String> statuses,
    required String? selectedFilter,
    required ValueChanged<String?> onFilterChanged,
    required String emptyMsg,
  }) {
    if (_isLoading && orders.isEmpty) {
      return const LoadingState();
    }

    if (_error != null && orders.isEmpty) {
      return ErrorState(error: _error!, onRetry: _onRefresh);
    }

    return Column(
      children: [
        _buildStatusChips(
          allOrders: orders,
          statuses: statuses,
          selected: selectedFilter,
          onChanged: onFilterChanged,
        ),
        const Divider(height: 1, color: AppLightTheme.dividerColor),
        Expanded(
          child: RefreshIndicator(
            color: AppLightTheme.goldPrimary,
            onRefresh: _onRefresh,
            child: filteredOrders.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: EmptyState(
                          message: emptyMsg,
                          icon: Icons.receipt_long_outlined,
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _buildOrderTile(filteredOrders[index], index),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChips({
    required List<OrderModel> allOrders,
    required List<String> statuses,
    required String? selected,
    required ValueChanged<String?> onChanged,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          StatusFilterChip(
            label: '${'all_statuses'.tr} (${allOrders.length})',
            isSelected: selected == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: 8),
          ...statuses.map((status) {
            final count = _statusCount(status, allOrders);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: StatusFilterChip(
                label: '${OrderHelpers.getStatusLabel(status)} ($count)',
                isSelected: selected == status,
                color: OrderHelpers.getStatusColor(status),
                onTap: () => onChanged(selected == status ? null : status),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderTile(OrderModel order, int index) {
    final dateStr = DateFormat(
      'yyyy/MM/dd \u2013 HH:mm',
    ).format(order.createdAt);
    final statusColor = OrderHelpers.getStatusColor(order.status);

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
              // Top row: ID + status badge
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
                      OrderHelpers.getStatusLabel(order.status),
                      style: TextStyles.bodyMedium().copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Price + items + date row
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
              // Upload payment button for Confirmed orders
              if (order.isConfirmed) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppLightTheme.dividerColor),
                const SizedBox(height: 10),
                Text(
                  'waiting_payment_upload'.tr,
                  style: TextStyles.bodyMedium().copyWith(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _pickAndUploadPayment(order),
                    icon: const Icon(
                      Icons.upload_file,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'upload_payment_receipt'.tr,
                      style: TextStyles.buttonText.copyWith(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppLightTheme.goldPrimary,
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
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 280.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, duration: 280.ms, curve: Curves.easeOut);
  }
}
