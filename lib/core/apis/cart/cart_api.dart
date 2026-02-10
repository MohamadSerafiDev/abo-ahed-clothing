import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/cart_model.dart';

class CartApi {
  final ApiService _apiService;

  CartApi(this._apiService);

  /// Get user's cart
  Future<CartModel?> getCart() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.cart);

      if (response.statusCode == 200) {
        return CartModel.fromJson(response.data);
      } else {
        throw Exception(response.error ?? 'Failed to fetch cart');
      }
    } catch (e) {
      throw Exception('Failed to fetch cart: ${e.toString()}');
    }
  }

  /// Delete item from cart
  Future<bool> deleteFromCart(String productId) async {
    try {
      final response = await _apiService.deleteRequest(
        ApiLinks.deleteFromCart(productId),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.error ?? 'Failed to remove item from cart');
      }
    } catch (e) {
      throw Exception('Failed to remove item from cart: ${e.toString()}');
    }
  }

  /// Clear entire cart
  Future<bool> clearCart(List<String> productIds) async {
    try {
      for (final productId in productIds) {
        await deleteFromCart(productId);
      }
      return true;
    } catch (e) {
      throw Exception('Failed to clear cart: ${e.toString()}');
    }
  }
}
