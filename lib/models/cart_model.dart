import 'package:abo_abed_clothing/models/product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final int quantity;

  CartItemModel({required this.id, required this.product, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['_id'] ?? '',
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'product': product.toJson(), 'quantity': quantity};
  }

  // Calculate total price for this item
  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({String? id, ProductModel? product, int? quantity}) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartModel {
  final String id;
  final String customer;
  final List<CartItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.customer,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? json['id'] ?? '',
      customer: json['customer'] ?? '',
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => CartItemModel.fromJson(item))
              .toList()
          : [],
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
      'customer': customer,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper to get total items count
  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  // Helper to check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Helper to check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  CartModel copyWith({
    String? id,
    String? customer,
    List<CartItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
