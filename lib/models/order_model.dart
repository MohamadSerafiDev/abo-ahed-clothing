import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:abo_abed_clothing/models/user_model.dart';

class OrderItemModel {
  final ProductModel product;
  final int quantity;

  OrderItemModel({required this.product, required this.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product.id, 'quantity': quantity};
  }

  // Calculate total price for this item
  double get totalPrice => product.price * quantity;
}

class OrderModel {
  final String id;
  final UserModel customer;
  final List<OrderItemModel> items;
  final double totalPrice;
  final String
  status; // 'Pending', 'Verified', 'OnWay', 'Delivered', 'Cancelled'
  final String screenshot; // Payment screenshot URL
  final UserModel? courier;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.customer,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.screenshot,
    this.courier,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      customer: UserModel.fromJson(json['customer']),
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => OrderItemModel.fromJson(item))
                .toList()
          : [],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      screenshot: json['screenshot'] ?? '',
      courier: json['courier'] != null
          ? UserModel.fromJson(json['courier'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customer': customer.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'screenshot': screenshot,
      if (courier != null) 'courier': courier!.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper to check status
  bool get isPending => status == 'Pending';
  bool get isVerified => status == 'Verified';
  bool get isOnWay => status == 'OnWay';
  bool get isDelivered => status == 'Delivered';
  bool get isCancelled => status == 'Cancelled';

  // Helper to get total items count
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    String? id,
    UserModel? customer,
    List<OrderItemModel>? items,
    double? totalPrice,
    String? status,
    String? screenshot,
    UserModel? courier,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      screenshot: screenshot ?? this.screenshot,
      courier: courier ?? this.courier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OrderListResponse {
  final List<OrderModel> orders;
  final int total;

  OrderListResponse({required this.orders, required this.total});

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      orders: json['orders'] != null
          ? (json['orders'] as List)
                .map((item) => OrderModel.fromJson(item))
                .toList()
          : [],
      total: json['total'] ?? 0,
    );
  }
}

// For checkout request
class CheckoutRequest {
  final List<OrderItemRequest> items;
  final double totalPrice;
  final String screenshot;

  CheckoutRequest({
    required this.items,
    required this.totalPrice,
    required this.screenshot,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'screenshot': screenshot,
    };
  }
}

class OrderItemRequest {
  final String productId;
  final int quantity;

  OrderItemRequest({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'product': productId, 'quantity': quantity};
  }
}
