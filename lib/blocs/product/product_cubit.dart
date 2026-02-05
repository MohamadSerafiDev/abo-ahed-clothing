import 'package:abo_abed_clothing/core/apis/product/product_api.dart';
import 'package:abo_abed_clothing/blocs/product/product_state.dart';
import 'package:abo_abed_clothing/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        emit(ProductFailure('Failed to load products'));
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
        emit(ProductFailure('Failed to load product details'));
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
    String? description,
    int stock = 1,
    List<MediaItemModel>? mediaItems,
  }) async {
    emit(ProductLoading());
    try {
      final product = await _productService.createProduct(
        title: title,
        price: price,
        condition: condition,
        category: category,
        description: description,
        stock: stock,
        mediaItems: mediaItems,
      );

      if (product != null) {
        emit(ProductActionSuccess('Product created successfully', product));
      } else {
        emit(ProductFailure('Failed to create product'));
      }
    } catch (e) {
      emit(ProductFailure(e.toString()));
    }
  }

  /// Update product (Admin only)
  Future<void> updateProduct(
    String productId, {
    double? price,
    String? description,
    int? stock,
    String? condition,
    String? category,
  }) async {
    emit(ProductLoading());
    try {
      final product = await _productService.updateProduct(
        productId,
        price: price,
        description: description,
        stock: stock,
        condition: condition,
        category: category,
      );

      if (product != null) {
        emit(ProductActionSuccess('Product updated successfully', product));
      } else {
        emit(ProductFailure('Failed to update product'));
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
        emit(ProductDeleted('Product deleted successfully'));
      } else {
        emit(ProductFailure('Failed to delete product'));
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
        emit(ProductAddedToCart('Product added to cart'));
      } else {
        emit(ProductFailure('Failed to add to cart'));
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
