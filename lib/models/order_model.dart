import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:abo_abed_clothing/models/user_model.dart';

class OrderItemModel {
  final ProductModel? product;
  final String? productId; // When product is not populated
  final int quantity;
  final double? priceAtPurchase;

  OrderItemModel({
    this.product,
    this.productId,
    required this.quantity,
    this.priceAtPurchase,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    ProductModel? product;
    String? productId;

    if (json['product'] is Map<String, dynamic>) {
      product = ProductModel.fromJson(json['product']);
      productId = product.id;
    } else if (json['product'] != null) {
      productId = json['product'].toString();
    }

    return OrderItemModel(
      product: product,
      productId: productId,
      quantity: json['quantity'] ?? 1,
      priceAtPurchase: json['priceAtPurchase'] != null
          ? (json['priceAtPurchase'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.id ?? productId,
      'quantity': quantity,
      if (priceAtPurchase != null) 'priceAtPurchase': priceAtPurchase,
    };
  }

  // Calculate total price for this item
  double get totalPrice {
    final price = priceAtPurchase ?? product?.price ?? 0;
    return price * quantity;
  }
}

class OrderModel {
  final String id;
  final dynamic customer; // UserModel (populated) or String (ID)
  final List<OrderItemModel> items;
  final double totalPrice;
  final String status;
  // Statuses: 'Pending', 'Confirmed', 'PaymentUnderReview', 'OnWay',
  //           'Delivered', 'Cancelled', 'Processing'
  final String? paymentImage;
  final String? address;
  final UserModel? courier;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.customer,
    required this.items,
    required this.totalPrice,
    required this.status,
    this.paymentImage,
    this.address,
    this.courier,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });

  /// Helper to get customer as UserModel (returns null if it's just an ID)
  UserModel? get customerModel =>
      customer is UserModel ? customer as UserModel : null;

  /// Helper to get customer ID regardless of populated or not
  String get customerId {
    if (customer is UserModel) return (customer as UserModel).id;
    if (customer is String) return customer as String;
    return '';
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle customer: could be populated object or just an ID string
    dynamic customer;
    if (json['customer'] is Map<String, dynamic>) {
      customer = UserModel.fromJson(json['customer']);
    } else {
      customer = json['customer']?.toString() ?? '';
    }

    // Handle items: backend may use 'products' or 'items' key
    final itemsList = json['products'] ?? json['items'] ?? [];

    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      customer: customer,
      items: itemsList is List
          ? itemsList
                .map(
                  (item) =>
                      OrderItemModel.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : [],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      paymentImage: json['paymentImage'],
      address: json['address'],
      courier:
          json['courier'] != null && json['courier'] is Map<String, dynamic>
          ? UserModel.fromJson(json['courier'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customer': customer is UserModel
          ? (customer as UserModel).toJson()
          : customer,
      'products': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      if (paymentImage != null) 'paymentImage': paymentImage,
      if (address != null) 'address': address,
      if (courier != null) 'courier': courier!.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt!.toIso8601String(),
    };
  }

  // Helper to check status
  bool get isPending => status == 'Pending';
  bool get isConfirmed => status == 'Confirmed';
  bool get isPaymentUnderReview => status == 'PaymentUnderReview';
  bool get isProcessing => status == 'Processing';
  bool get isOnWay => status == 'OnWay';
  bool get isDelivered => status == 'Delivered';
  bool get isCancelled => status == 'Cancelled';

  // Helper to get total items count
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    String? id,
    dynamic customer,
    List<OrderItemModel>? items,
    double? totalPrice,
    String? status,
    String? paymentImage,
    String? address,
    UserModel? courier,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentImage: paymentImage ?? this.paymentImage,
      address: address ?? this.address,
      courier: courier ?? this.courier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
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

/// Request to create a new order (from server-side cart)
class CreateOrderRequest {
  final String? address;

  CreateOrderRequest({this.address});

  Map<String, dynamic> toJson() {
    return {if (address != null) 'address': address};
  }
}

/// Request for admin to verify payment and assign courier
class VerifyPaymentRequest {
  final bool isPaymentValid;
  final String? adminNote;
  final String? courierId;
  final String? addressDetails;

  VerifyPaymentRequest({
    required this.isPaymentValid,
    this.adminNote,
    this.courierId,
    this.addressDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'isPaymentValid': isPaymentValid,
      if (adminNote != null) 'adminNote': adminNote,
      if (courierId != null) 'courierId': courierId,
      if (addressDetails != null) 'addressDetails': addressDetails,
    };
  }
}
