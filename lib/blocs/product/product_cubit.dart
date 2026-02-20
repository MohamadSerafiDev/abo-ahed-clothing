import 'dart:developer';

import 'package:abo_abed_clothing/core/apis/product/product_api.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductApi _productService;

  ProductCubit(this._productService) : super(ProductInitial());

  /// Get all products
  Future<void> getAllProducts() async {
    emit(ProductLoading());
    try {
      final response = await _productService.getAllProducts();
      if (response != null) {
        emit(ProductsLoaded(response.products));
      } else {
        emit(ProductFailure('products_load_failed'));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  /// Get product details
  Future<void> getProductDetails(String productId) async {
    emit(ProductLoading());
    try {
      final product = await _productService.getProductById(productId);
      if (product != null) {
        emit(ProductDetailsLoaded(product));
      } else {
        emit(ProductFailure('product_details_load_failed'));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  /// Create product (Admin only)
  Future<void> createProduct({
    required String title,
    required double price,
    required String condition,
    required String category,
    String? size,
    String? description,
    int stock = 1,
    List<String> imagePaths = const [],
  }) async {
    emit(ProductLoading());
    try {
      final product = await _productService.createProduct(
        title: title,
        price: price,
        condition: condition,
        category: category,
        size: size,
        description: description,
        stock: stock,
        imagePaths: imagePaths,
      );

      if (product != null) {
        emit(ProductActionSuccess('product_created_successfully', product));
      } else {
        emit(ProductFailure('product_create_failed'));
      }
    } catch (e) {
      log(e.toString());
      emit(ProductFailure(e.toString()));
    }
  }

  /// Update product (Admin only)
  Future<void> updateProduct(
    String productId, {
    String? title,
    double? price,
    String? description,
    int? stock,
    String? condition,
    String? category,
    String? size,
  }) async {
    emit(ProductLoading());
    try {
      final product = await _productService.updateProduct(
        productId,
        title: title,
        price: price,
        description: description,
        stock: stock,
        condition: condition,
        category: category,
        size: size,
      );

      if (product != null) {
        emit(ProductActionSuccess('product_updated_successfully', product));
      } else {
        emit(ProductFailure('product_update_failed'));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  /// Delete product (Admin only)
  Future<void> deleteProduct(String productId) async {
    emit(ProductLoading());
    try {
      final success = await _productService.deleteProduct(productId);
      if (success) {
        emit(ProductDeleted('product_deleted_successfully'));
      } else {
        emit(ProductFailure('product_delete_failed'));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  /// Add product to cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    emit(ProductLoading());
    try {
      final success = await _productService.addToCart(
        productId: productId,
        quantity: quantity,
      );

      if (success) {
        emit(ProductAddedToCart('product_added_to_cart'));
      } else {
        emit(ProductFailure('add_to_cart_failed'));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  /// Reset state
  void reset() {
    emit(ProductInitial());
  }
}
