import 'package:abo_abed_clothing/core/apis/order/order_api.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderApi _orderService;

  OrderCubit(this._orderService) : super(OrderInitial());

  /// Checkout order
  Future<void> checkout(CheckoutRequest request) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.checkout(request);
      if (order != null) {
        emit(OrderSuccess('Order placed successfully', order));
      } else {
        emit(OrderFailure('Failed to checkout'));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Get pending payments (Admin only)
  Future<void> getPendingPayments() async {
    emit(OrderLoading());
    try {
      final response = await _orderService.getPendingPayments();
      if (response != null) {
        emit(PendingPaymentsLoaded(response.orders));
      } else {
        emit(OrderFailure('Failed to load pending payments'));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Verify payment (Admin only)
  Future<void> verifyPayment({
    required String orderId,
    required String status,
    required String courierId,
  }) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.verifyPayment(
        orderId: orderId,
        status: status,
        courierId: courierId,
      );

      if (order != null) {
        emit(OrderSuccess('Payment verified and courier assigned', order));
      } else {
        emit(OrderFailure('Failed to verify payment'));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Reset state
  void reset() {
    emit(OrderInitial());
  }
}
