import 'package:abo_abed_clothing/models/order_model.dart';

abstract class ShippingState {}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class DeliveriesLoaded extends ShippingState {
  final List<OrderModel> deliveries;

  DeliveriesLoaded(this.deliveries);
}

class ShippingSuccess extends ShippingState {
  final String message;
  final OrderModel order;

  ShippingSuccess(this.message, this.order);
}

class ShippingFailure extends ShippingState {
  final String error;

  ShippingFailure(this.error);
}
