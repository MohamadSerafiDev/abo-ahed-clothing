import 'package:abo_abed_clothing/models/shipping_model.dart';

abstract class ShippingState {}

class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class DeliveriesLoaded extends ShippingState {
  final List<ShippingModel> deliveries;

  DeliveriesLoaded(this.deliveries);
}

class ShippingSuccess extends ShippingState {
  final String message;
  final ShippingModel shipping;

  ShippingSuccess(this.message, this.shipping);
}

class ShippingFailure extends ShippingState {
  final String error;

  ShippingFailure(this.error);
}
