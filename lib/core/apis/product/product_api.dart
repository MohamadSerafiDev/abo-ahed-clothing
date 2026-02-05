import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/product_model.dart';

class ProductApi {
  final ApiService _apiService;

  ProductApi(this._apiService);

  /// Get all products
  Future<ProductListResponse?> getAllProducts() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.products);

      if (response.statusCode == 200) {
        return ProductListResponse.fromJson(response.data);
      } else {
        throw Exception(response.error ?? 'Failed to fetch products');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  /// Get product details by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final response = await _apiService.getRequest(
        ApiLinks.productById(productId),
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data['product']);
      } else {
        throw Exception(response.error ?? 'Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: ${e.toString()}');
    }
  }

  /// Create a new ProductModel (Admin only)
  Future<ProductModel?> createProduct({
    required String title,
    required double price,
    required String condition,
    required String category,
    String? description,
    int stock = 1,
    List<MediaItemModel>? mediaItems,
  }) async {
    try {
      final data = {
        'title': title,
        'price': price,
        'condition': condition,
        'category': category,
        if (description != null) 'description': description,
        'stock': stock,
        if (mediaItems != null)
          'mediaItems': mediaItems.map((item) => item.toJson()).toList(),
      };

      final response = await _apiService.postRequest(ApiLinks.products, data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProductModel.fromJson(response.data['product']);
      } else {
        throw Exception(response.error ?? 'Failed to create product');
      }
    } catch (e) {
      throw Exception('Failed to create product: ${e.toString()}');
    }
  }

  /// Update product (Admin only)
  Future<ProductModel?> updateProduct(
    String productId, {
    double? price,
    String? description,
    int? stock,
    String? condition,
    String? category,
  }) async {
    try {
      final data = {
        if (price != null) 'price': price,
        if (description != null) 'description': description,
        if (stock != null) 'stock': stock,
        if (condition != null) 'condition': condition,
        if (category != null) 'category': category,
      };

      final response = await _apiService.putRequest(
        ApiLinks.productById(productId),
        data,
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data['product']);
      } else {
        throw Exception(response.error ?? 'Failed to update product');
      }
    } catch (e) {
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  /// Delete product (Admin only)
  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await _apiService.deleteRequest(
        ApiLinks.productById(productId),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.error ?? 'Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: ${e.toString()}');
    }
  }

  /// Add product to cart
  Future<bool> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final data = {'productId': productId, 'quantity': quantity};

      final response = await _apiService.postRequest(ApiLinks.addToCart, data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(response.error ?? 'Failed to add to cart');
      }
    } catch (e) {
      throw Exception('Failed to add to cart: ${e.toString()}');
    }
  }
}
