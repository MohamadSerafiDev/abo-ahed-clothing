import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/shipping_model.dart';

class ShippingApi {
  final ApiService _apiService;

  ShippingApi(this._apiService);

  /// Get courier's deliveries (Courier only)
  Future<List<ShippingModel>> getMyDeliveries() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.myDeliveries);

      if (response.statusCode == 200) {
        // Backend returns a plain JSON array of shipping documents
        if (response.data is List) {
          return (response.data as List)
              .map((item) => ShippingModel.fromJson(item))
              .toList();
        }
        // In case it's wrapped in an object
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final list = data['deliveries'] ?? data['data'] ?? [];
          if (list is List) {
            return list
                .map((item) => ShippingModel.fromJson(item))
                .toList();
          }
        }
        return [];
      } else {
        throw Exception(response.error ?? 'Failed to fetch deliveries');
      }
    } catch (e) {
      throw Exception('Failed to fetch deliveries: ${e.toString()}');
    }
  }

  /// Update shipping status (Courier only)
  Future<ShippingModel?> updateShippingStatus({
    required String shippingId,
    required String status,
  }) async {
    try {
      final data = {'status': status};

      final response = await _apiService.patchRequest(
        ApiLinks.updateShippingStatus(shippingId),
        data,
      );

      if (response.statusCode == 200) {
        return ShippingModel.fromJson(response.data['shipping']);
      } else {
        throw Exception(response.error ?? 'Failed to update shipping status');
      }
    } catch (e) {
      throw Exception('Failed to update shipping status: ${e.toString()}');
    }
  }
}
