import 'package:abo_abed_clothing/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;

  ProductsLoaded(this.products);
}

class ProductDetailsLoaded extends ProductState {
  final ProductModel product;

  ProductDetailsLoaded(this.product);
}

class ProductActionSuccess extends ProductState {
  final String message;
  final ProductModel? product;

  ProductActionSuccess(this.message, [this.product]);
}

class ProductDeleted extends ProductState {
  final String message;

  ProductDeleted(this.message);
}

class ProductAddedToCart extends ProductState {
  final String message;

  ProductAddedToCart(this.message);
}

class ProductFailure extends ProductState {
  final String error;

  ProductFailure(this.error);
}
