import 'package:abo_abed_clothing/models/order_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final String message;
  final OrderModel order;

  OrderSuccess(this.message, this.order);
}

class PendingPaymentsLoaded extends OrderState {
  final List<OrderModel> orders;

  PendingPaymentsLoaded(this.orders);
}

class OrderFailure extends OrderState {
  final String error;

  OrderFailure(this.error);
}
