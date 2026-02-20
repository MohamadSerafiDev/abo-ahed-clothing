import 'dart:developer';

import 'package:abo_abed_clothing/core/apis/order/order_api.dart';
import 'package:abo_abed_clothing/blocs/order/order_state.dart';
import 'package:abo_abed_clothing/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderApi _orderService;

  OrderCubit(this._orderService) : super(OrderInitial());

  /// Create order from cart — POST /orders
  Future<void> createOrder({String? address}) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.createOrder(
        CreateOrderRequest(address: address),
      );
      if (order != null) {
        emit(OrderSuccess('order_placed_success', order));
      } else {
        emit(OrderFailure('order_create_failed'));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Get active orders — GET /orders/active
  Future<void> getActiveOrders() async {
    emit(OrderLoading());
    try {
      final orders = await _orderService.getActiveOrders();
      emit(ActiveOrdersLoaded(orders));
    } catch (e) {
      log(e.toString());
      emit(OrderFailure('active_orders_failed'.tr));
    }
  }

  /// Get order history — GET /orders/history
  Future<void> getOrdersHistory() async {
    emit(OrderLoading());
    try {
      final orders = await _orderService.getOrdersHistory();
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderFailure('order_history_failed'.tr));
    }
  }

  /// Upload payment image — PATCH /orders/upload-payment/:orderId
  Future<void> uploadPaymentImage({
    required String orderId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.uploadPaymentImage(
        orderId: orderId,
        imageBytes: imageBytes,
        fileName: fileName,
      );
      if (order != null) {
        emit(OrderSuccess('payment_image_uploaded'.tr, order));
      } else {
        emit(OrderFailure('payment_image_upload_failed'.tr));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Admin confirm order — PATCH /orders/admin/confirm/:orderId
  Future<void> adminConfirmOrder(String orderId) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.adminConfirmOrder(orderId);
      if (order != null) {
        emit(OrderSuccess('order_confirmed_success'.tr, order));
      } else {
        emit(OrderFailure('order_confirm_failed'.tr));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Admin verify payment — PATCH /orders/admin/verify-payment/:orderId
  Future<void> verifyOrderPayment({
    required String orderId,
    required bool isPaymentValid,
    String? adminNote,
    String? courierId,
    String? addressDetails,
  }) async {
    emit(OrderLoading());
    try {
      final result = await _orderService.verifyOrderPayment(
        orderId: orderId,
        request: VerifyPaymentRequest(
          isPaymentValid: isPaymentValid,
          adminNote: adminNote,
          courierId: courierId,
          addressDetails: addressDetails,
        ),
      );
      if (result != null) {
        emit(
          PaymentVerified(result['message'] ?? 'payment_verified'.tr, result),
        );
      } else {
        emit(OrderFailure('payment_verify_failed'.tr));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Get pending payments (Admin only) — GET /orders/pending-payments
  Future<void> getPendingPayments() async {
    emit(OrderLoading());
    try {
      final response = await _orderService.getPendingPayments();
      if (response != null) {
        emit(PendingPaymentsLoaded(response.orders));
      } else {
        emit(OrderFailure('pending_payments_failed'.tr));
      }
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  /// Confirm delivery (Admin/Courier) — PATCH /orders/delivery/confirm/:orderId
  Future<void> confirmDelivery(String orderId) async {
    emit(OrderLoading());
    try {
      final order = await _orderService.confirmDelivery(orderId);
      if (order != null) {
        emit(OrderSuccess('delivery_confirmed_success'.tr, order));
      } else {
        emit(OrderFailure('delivery_confirm_failed'.tr));
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
