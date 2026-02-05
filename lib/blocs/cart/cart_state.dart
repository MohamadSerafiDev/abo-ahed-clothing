import 'package:abo_abed_clothing/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;

  CartLoaded(this.cart);
}

class CartActionSuccess extends CartState {
  final String message;

  CartActionSuccess(this.message);
}

class CartFailure extends CartState {
  final String error;

  CartFailure(this.error);
}
