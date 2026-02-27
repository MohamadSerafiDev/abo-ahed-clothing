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

class ActiveOrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  ActiveOrdersLoaded(this.orders);
}

class OrderHistoryLoaded extends OrderState {
  final List<OrderModel> orders;

  OrderHistoryLoaded(this.orders);
}

class PaymentVerified extends OrderState {
  final String message;
  final Map<String, dynamic> data;

  PaymentVerified(this.message, this.data);
}

class AdminAllOrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  AdminAllOrdersLoaded(this.orders);
}

class OrderFailure extends OrderState {
  final String error;

  OrderFailure(this.error);
}
