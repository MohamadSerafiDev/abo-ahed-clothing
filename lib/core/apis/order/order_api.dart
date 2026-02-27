import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/order_model.dart';

class OrderApi {
  final ApiService _apiService;

  OrderApi(this._apiService);

  /// Get all orders (Admin) — GET /orders
  Future<List<OrderModel>> getAllOrdersAdmin() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.allOrders);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final list = data['orders'] ?? [];
        if (list is List) {
          return list.map((item) => OrderModel.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception(response.error ?? 'Failed to fetch all orders');
      }
    } catch (e) {
      throw Exception('Failed to fetch all orders: ${e.toString()}');
    }
  }

  /// Create order from server-side cart — POST /orders
  Future<OrderModel?> createOrder(CreateOrderRequest request) async {
    try {
      final response = await _apiService.postRequest(
        ApiLinks.createOrder,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  /// Get active orders for current customer — GET /orders/active
  Future<List<OrderModel>> getActiveOrders() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.activeOrders);

      if (response.statusCode == 200) {
        // Response is a direct array of orders
        if (response.data is List) {
          return (response.data as List)
              .map((item) => OrderModel.fromJson(item))
              .toList();
        }
        // In case the response is wrapped in an object
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('orders')) {
          return (data['orders'] as List)
              .map((item) => OrderModel.fromJson(item))
              .toList();
        }
        return [];
      } else {
        throw Exception(response.error ?? 'Failed to fetch active orders');
      }
    } catch (e) {
      throw Exception('Failed to fetch active orders: ${e.toString()}');
    }
  }

  /// Get order history for current customer — GET /orders/history
  Future<List<OrderModel>> getOrdersHistory() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.ordersHistory);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        // Backend returns { success, count, history } or { message, data }
        final list = data['history'] ?? data['data'] ?? [];
        if (list is List) {
          return list.map((item) => OrderModel.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception(response.error ?? 'Failed to fetch orders history');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders history: ${e.toString()}');
    }
  }

  /// Upload payment image — PATCH /orders/upload-payment/:orderId
  Future<OrderModel?> uploadPaymentImage({
    required String orderId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    try {
      final response = await _apiService.multipartPatch(
        ApiLinks.uploadPaymentImage(orderId),
        imageBytes,
        fileName,
        fieldName: 'paymentImage',
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to upload payment image');
      }
    } catch (e) {
      throw Exception('Failed to upload payment image: ${e.toString()}');
    }
  }

  /// Admin confirm order — PATCH /orders/admin/confirm/:orderId
  Future<OrderModel?> adminConfirmOrder(String orderId) async {
    try {
      final response = await _apiService.patchRequest(
        ApiLinks.adminConfirmOrder(orderId),
        {},
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to confirm order');
      }
    } catch (e) {
      throw Exception('Failed to confirm order: ${e.toString()}');
    }
  }

  /// Admin verify payment and assign courier — PATCH /orders/admin/verify-payment/:orderId
  Future<Map<String, dynamic>?> verifyOrderPayment({
    required String orderId,
    required VerifyPaymentRequest request,
  }) async {
    try {
      final response = await _apiService.patchRequest(
        ApiLinks.verifyPayment(orderId),
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Failed to verify payment');
      }
    } catch (e) {
      throw Exception('Failed to verify payment: ${e.toString()}');
    }
  }

  /// Get pending payments (Admin only) — GET /orders/pending-payments
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

  /// Confirm delivery (Admin/Courier) — PATCH /orders/delivery/confirm/:orderId
  Future<OrderModel?> confirmDelivery(String orderId) async {
    try {
      final response = await _apiService.patchRequest(
        ApiLinks.confirmDelivery(orderId),
        {},
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['order']);
      } else {
        throw Exception(response.error ?? 'Failed to confirm delivery');
      }
    } catch (e) {
      throw Exception('Failed to confirm delivery: ${e.toString()}');
    }
  }
}
