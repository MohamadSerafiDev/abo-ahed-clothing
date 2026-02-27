import 'package:abo_abed_clothing/models/order_model.dart';

class ShippingModel {
  final String id;
  final OrderModel? order;
  final String? orderId;
  final String courierId;
  final String addressDetails;
  final String status; // 'Preparing', 'OnWay', 'Delivered', 'Failed'
  final String? trackingNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShippingModel({
    required this.id,
    this.order,
    this.orderId,
    required this.courierId,
    required this.addressDetails,
    required this.status,
    this.trackingNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    OrderModel? order;
    String? orderId;

    if (json['order'] is Map<String, dynamic>) {
      order = OrderModel.fromJson(json['order']);
      orderId = order.id;
    } else if (json['order'] != null) {
      orderId = json['order'].toString();
    }

    return ShippingModel(
      id: json['_id'] ?? json['id'] ?? '',
      order: order,
      orderId: orderId,
      courierId: json['courier']?.toString() ?? '',
      addressDetails: json['addressDetails'] ?? '',
      status: json['status'] ?? 'Preparing',
      trackingNumber: json['trackingNumber'],
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Status helpers
  bool get isPreparing => status == 'Preparing';
  bool get isOnWay => status == 'OnWay';
  bool get isDelivered => status == 'Delivered';
  bool get isFailed => status == 'Failed';

  /// Customer name from populated order
  String get customerName => order?.customerModel?.name ?? '';
  String get customerPhone => order?.customerModel?.phone ?? '';
  String get customerAddress => order?.customerModel?.address ?? '';
  double get orderTotalPrice => order?.totalPrice ?? 0;
  int get orderItemsCount => order?.itemsCount ?? 0;
}
