import 'package:abo_abed_clothing/core/apis/shipping/shipping_api.dart';
import 'package:abo_abed_clothing/blocs/shipping/shipping_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingApi _shippingService;

  ShippingCubit(this._shippingService) : super(ShippingInitial());

  /// Get courier's deliveries
  Future<void> getMyDeliveries() async {
    emit(ShippingLoading());
    try {
      final response = await _shippingService.getMyDeliveries();
      if (response != null) {
        emit(DeliveriesLoaded(response.orders));
      } else {
        emit(ShippingFailure('Failed to load deliveries'));
      }
    } catch (e) {
      emit(ShippingFailure(e.toString()));
    }
  }

  /// Update shipping status
  Future<void> updateShippingStatus({
    required String orderId,
    required String status,
  }) async {
    emit(ShippingLoading());
    try {
      final order = await _shippingService.updateShippingStatus(
        orderId: orderId,
        status: status,
      );

      if (order != null) {
        emit(ShippingSuccess('Status updated successfully', order));
        // Reload deliveries after update
        await getMyDeliveries();
      } else {
        emit(ShippingFailure('Failed to update status'));
      }
    } catch (e) {
      emit(ShippingFailure(e.toString()));
    }
  }

  /// Reset state
  void reset() {
    emit(ShippingInitial());
  }
}
