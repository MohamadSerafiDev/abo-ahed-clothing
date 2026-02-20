import 'dart:developer';

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
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('product') && data['product'] != null) {
            return ProductModel.fromJson(data['product']);
          } else if (data.containsKey('_id') || data.containsKey('id')) {
            // Fallback: the product is at the root
            return ProductModel.fromJson(data);
          }
        }
        throw Exception('Product data not found in response');
      } else {
        throw Exception(response.error ?? 'Failed to fetch product details');
      }
    } catch (e) {
      throw Exception('Failed to fetch product details: ${e.toString()}');
    }
  }

  /// Create a new ProductModel (Admin only) — multipart with media files
  Future<ProductModel?> createProduct({
    required String title,
    required double price,
    required String condition,
    required String category,
    String? size,
    String? description,
    int stock = 1,
    List<String> imagePaths = const [],
  }) async {
    try {
      final fields = <String, String>{
        'title': title,
        'price': price.toString(),
        'condition': condition,
        'category': category,
        'stock': stock.toString(),
        if (size != null) 'size': size,
        if (description != null) 'description': description,
      };

      final response = await _apiService.multipartPostWithFiles(
        ApiLinks.products,
        fields: fields,
        filePaths: imagePaths,
        fileFieldName: 'media',
      );
      log(response.statusCode.toString(), name: 'create product SC');
      log(response.data.toString(), name: 'create product response');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('product') && data['product'] != null) {
            return ProductModel.fromJson(data['product']);
          } else if (data.containsKey('_id') || data.containsKey('id')) {
            return ProductModel.fromJson(data);
          }
        }
        throw Exception('Product data not found in response');
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
    String? title,
    double? price,
    String? description,
    int? stock,
    String? condition,
    String? category,
    String? size,
  }) async {
    try {
      final fields = <String, String>{
        if (title != null) 'title': title,
        if (price != null) 'price': price.toString(),
        if (description != null) 'description': description,
        if (stock != null) 'stock': stock.toString(),
        if (condition != null) 'condition': condition,
        if (category != null) 'category': category,
        if (size != null) 'size': size,
      };
      final response = await _apiService.putRequest(
        ApiLinks.productById(productId),
        fields,
      );
      log(response.data.toString(), name: 'update product response');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('updatedProduct') &&
              data['updatedProduct'] != null) {
            return ProductModel.fromJson(data['updatedProduct']);
          }
          if (data.containsKey('product') && data['product'] != null) {
            return ProductModel.fromJson(data['product']);
          } else if (data.containsKey('_id') || data.containsKey('id')) {
            return ProductModel.fromJson(data);
          }
        }
        throw Exception('Product data not found in response');
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
