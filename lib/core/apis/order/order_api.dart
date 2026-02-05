import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/order_model.dart';

class OrderApi {
  final ApiService _apiService;

  OrderApi(this._apiService);

  /// Checkout - Send order to admin for verification
  Future<OrderModel?> checkout(CheckoutRequest request) async {
    try {
      final response = await _apiService.postRequest(
        ApiLinks.checkout,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to checkout');
      }
    } catch (e) {
      throw Exception('Failed to checkout: ${e.toString()}');
    }
  }

  /// Get pending payments (Admin only)
  Future<OrderListResponse?> getPendingPayments() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.pendingPayments);

      if (response.statusCode == 200) {
        return OrderListResponse.fromJson(response.data);
      } else {
        throw Exception(response.error ?? 'Failed to fetch pending payments');
      }
    } catch (e) {
      throw Exception('Failed to fetch pending payments: ${e.toString()}');
    }
  }

  /// Verify payment and assign courier (Admin only)
  Future<OrderModel?> verifyPayment({
    required String orderId,
    required String status,
    required String courierId,
  }) async {
    try {
      final data = {'status': status, 'courierId': courierId};

      final response = await _apiService.putRequest(
        ApiLinks.verifyPayment(orderId),
        data,
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to verify payment');
      }
    } catch (e) {
      throw Exception('Failed to verify payment: ${e.toString()}');
    }
  }
}
