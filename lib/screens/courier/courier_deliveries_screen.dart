import 'package:abo_abed_clothing/blocs/shipping/shipping_cubit.dart';
import 'package:abo_abed_clothing/blocs/shipping/shipping_state.dart';
import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/shipping_helpers.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/models/shipping_model.dart';
import 'package:abo_abed_clothing/widgets/common/state_widgets.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:abo_abed_clothing/widgets/order/status_filter_chip.dart';
import 'package:abo_abed_clothing/widgets/shipping/delivery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CourierDeliveriesScreen extends StatefulWidget {
  const CourierDeliveriesScreen({super.key});

  @override
  State<CourierDeliveriesScreen> createState() =>
      _CourierDeliveriesScreenState();
}

class _CourierDeliveriesScreenState extends State<CourierDeliveriesScreen> {
  String? _selectedStatus;
  List<ShippingModel> _allDeliveries = [];
  bool _isLoading = true;
  String? _error;

  static const List<String> _statuses = ['Preparing', 'OnWay', 'Failed'];

  @override
  void initState() {
    super.initState();
    context.read<ShippingCubit>().getMyDeliveries();
  }

  List<ShippingModel> get _filteredDeliveries {
    if (_selectedStatus == null) return _allDeliveries;
    return _allDeliveries.where((d) => d.status == _selectedStatus).toList();
  }

  int _statusCount(String status) {
    return _allDeliveries.where((d) => d.status == status).length;
  }

  Future<void> _refresh() async {
    context.read<ShippingCubit>().getMyDeliveries();
  }

  void _confirmStatusUpdate(ShippingModel delivery, String newStatus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('confirm_status_change'.tr, style: TextStyles.titleLarge()),
        content: Text(
          '${'change_status_to'.tr} ${ShippingHelpers.getStatusLabel(newStatus)}?',
          style: TextStyles.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ShippingCubit>().updateShippingStatus(
                shippingId: delivery.id,
                status: newStatus,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppLightTheme.goldPrimary,
            ),
            child: Text(
              'confirm'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callCustomer(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightTheme.backgroundWhite,
      appBar: AppBar(
        title: Text('my_deliveries'.tr, style: TextStyles.titleLarge()),
        centerTitle: true,
        backgroundColor: AppLightTheme.backgroundWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ShippingCubit, ShippingState>(
        listener: (context, state) {
          if (state is DeliveriesLoaded) {
            setState(() {
              _allDeliveries = state.deliveries;
              _isLoading = false;
              _error = null;
            });
          } else if (state is ShippingLoading) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          } else if (state is ShippingFailure) {
            setState(() {
              _isLoading = false;
              _error = state.error;
            });
            AppSnackbar.showError(message: state.error);
          } else if (state is ShippingSuccess) {
            AppSnackbar.showSuccess(message: state.message);
          }
        },
        builder: (context, state) {
          if (_isLoading && _allDeliveries.isEmpty) {
            return const LoadingState();
          }
          if (_error != null && _allDeliveries.isEmpty) {
            return ErrorState(error: _error!, onRetry: _refresh);
          }

          return Column(
            children: [
              _buildStatusChips(),
              const Divider(height: 1, color: AppLightTheme.dividerColor),
              Expanded(
                child: RefreshIndicator(
                  color: AppLightTheme.goldPrimary,
                  onRefresh: _refresh,
                  child: _filteredDeliveries.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: EmptyState(
                                message: 'no_deliveries_found'.tr,
                                icon: Icons.local_shipping_outlined,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredDeliveries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final d = _filteredDeliveries[i];
                            return DeliveryCard(
                              delivery: d,
                              index: i,
                              onCallCustomer: d.customerPhone.isNotEmpty
                                  ? () => _callCustomer(d.customerPhone)
                                  : null,
                              onStatusUpdate: (newStatus) =>
                                  _confirmStatusUpdate(d, newStatus),
                            );
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
          StatusFilterChip(
            label: '${'all_statuses'.tr} (${_allDeliveries.length})',
            isSelected: _selectedStatus == null,
            onTap: () => setState(() => _selectedStatus = null),
          ),
          const SizedBox(width: 8),
          ..._statuses.map((status) {
            final count = _statusCount(status);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: StatusFilterChip(
                label: '${ShippingHelpers.getStatusLabel(status)} ($count)',
                isSelected: _selectedStatus == status,
                color: ShippingHelpers.getStatusColor(status),
                onTap: () {
                  setState(() {
                    _selectedStatus = _selectedStatus == status ? null : status;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
