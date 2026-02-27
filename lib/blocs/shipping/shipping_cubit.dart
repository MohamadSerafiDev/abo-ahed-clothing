import 'package:abo_abed_clothing/core/apis/shipping/shipping_api.dart';
import 'package:abo_abed_clothing/blocs/shipping/shipping_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ShippingCubit extends Cubit<ShippingState> {
  final ShippingApi _shippingService;

  ShippingCubit(this._shippingService) : super(ShippingInitial());

  /// Get courier's deliveries
  Future<void> getMyDeliveries() async {
    emit(ShippingLoading());
    try {
      final deliveries = await _shippingService.getMyDeliveries();
      emit(DeliveriesLoaded(deliveries));
    } catch (e) {
      emit(ShippingFailure(e.toString()));
    }
  }

  /// Update shipping status
  Future<void> updateShippingStatus({
    required String shippingId,
    required String status,
  }) async {
    emit(ShippingLoading());
    try {
      final shipping = await _shippingService.updateShippingStatus(
        shippingId: shippingId,
        status: status,
      );

      if (shipping != null) {
        emit(ShippingSuccess('shipping_status_updated'.tr, shipping));
        // Reload deliveries after update
        await getMyDeliveries();
      } else {
        emit(ShippingFailure('shipping_update_failed'.tr));
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
