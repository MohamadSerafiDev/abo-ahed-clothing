import 'package:abo_abed_clothing/core/apis/cart/cart_api.dart';
import 'package:abo_abed_clothing/blocs/cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  final CartApi _cartService;

  CartCubit(this._cartService) : super(CartInitial());

  /// Get user's cart
  Future<void> getCart() async {
    emit(CartLoading());
    try {
      final cart = await _cartService.getCart();
      if (cart != null) {
        emit(CartLoaded(cart));
      } else {
        emit(CartFailure('Failed to load cart'));
      }
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String productId) async {
    emit(CartLoading());
    try {
      final success = await _cartService.deleteFromCart(productId);
      if (success) {
        emit(CartActionSuccess('Item removed from cart'));
        // Reload cart after removal
        await getCart();
      } else {
        emit(CartFailure('Failed to remove item'));
      }
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  /// Clear entire cart
  Future<void> clearCart(List<String> productIds) async {
    emit(CartLoading());
    try {
      final success = await _cartService.clearCart(productIds);
      if (success) {
        emit(CartActionSuccess('Cart cleared successfully'));
        emit(CartInitial());
      } else {
        emit(CartFailure('Failed to clear cart'));
      }
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  /// Reset state
  void reset() {
    emit(CartInitial());
  }
}
