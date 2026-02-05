class MediaItemModel {
  final String url;
  final String type; // 'image' or 'video'

  MediaItemModel({required this.url, required this.type});

  factory MediaItemModel.fromJson(Map<String, dynamic> json) {
    return MediaItemModel(
      url: json['url'] ?? '',
      type: json['type'] ?? 'image',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'type': type};
  }
}

class ProductModel {
  final String id;
  final String title;
  final double price;
  final String condition; // 'New' or 'Used'
  final String category; // 'Men', 'Women', 'Kids'
  final String? description;
  final int stock;
  final List<MediaItemModel> mediaItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.condition,
    required this.category,
    this.description,
    required this.stock,
    required this.mediaItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      condition: json['condition'] ?? 'New',
      category: json['category'] ?? 'Men',
      description: json['description'],
      stock: json['stock'] ?? 0,
      mediaItems: json['mediaItems'] != null
          ? (json['mediaItems'] as List)
                .map((item) => MediaItemModel.fromJson(item))
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
      'title': title,
      'price': price,
      'condition': condition,
      'category': category,
      if (description != null) 'description': description,
      'stock': stock,
      'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? title,
    double? price,
    String? condition,
    String? category,
    String? description,
    int? stock,
    List<MediaItemModel>? mediaItems,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      category: category ?? this.category,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      mediaItems: mediaItems ?? this.mediaItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper to get first image
  String? get firstImageUrl {
    final images = mediaItems.where((item) => item.type == 'image').toList();
    return images.isNotEmpty ? images.first.url : null;
  }

  // Helper to check if in stock
  bool get isInStock => stock > 0;
}

class ProductListResponse {
  final List<ProductModel> products;
  final int total;

  ProductListResponse({required this.products, required this.total});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: json['products'] != null
          ? (json['products'] as List)
                .map((item) => ProductModel.fromJson(item))
                .toList()
          : [],
      total: json['total'] ?? 0,
    );
  }
}
