import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/order_model.dart';

class ShippingApi {
  final ApiService _apiService;

  ShippingApi(this._apiService);

  /// Get courier's deliveries (Courier only)
  Future<OrderListResponse?> getMyDeliveries() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.myDeliveries);

      if (response.statusCode == 200) {
        return OrderListResponse.fromJson(response.data);
      } else {
        throw Exception(response.error ?? 'Failed to fetch deliveries');
      }
    } catch (e) {
      throw Exception('Failed to fetch deliveries: ${e.toString()}');
    }
  }

  /// Update shipping status (Courier only)
  Future<OrderModel?> updateShippingStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final data = {'status': status};

      final response = await _apiService.patchRequest(
        ApiLinks.updateShippingStatus(orderId),
        data,
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to update shipping status');
      }
    } catch (e) {
      throw Exception('Failed to update shipping status: ${e.toString()}');
    }
  }
}
