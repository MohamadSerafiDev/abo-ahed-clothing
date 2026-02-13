// ignore_for_file: constant_identifier_names

/// API Endpoints for Abu Abed Clothing Store
/// Base URL: http://192.168.59.55:5000/api
class ApiLinks {
  // Base URL
  static const String BASE_URL = 'http://192.168.59.55:5000/api';

  // ==================== AUTH ENDPOINTS ====================
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String signUp = '/auth/signup';
  static const String userInfo = '/auth/me';

  // ==================== PRODUCT ENDPOINTS ====================
  static const String products = '/products';

  // Product with ID (for update, delete, get details)
  static String productById(String id) => '/products/$id';

  // Cart operations
  static const String addToCart = '/products/cart/add';

  // ==================== CART ENDPOINTS ====================
  static const String cart = '/cart';

  // Delete from cart
  static String deleteFromCart(String productId) => '/cart/$productId';

  // ==================== ORDER ENDPOINTS ====================
  static const String checkout = '/orders/checkout';
  static const String pendingPayments = '/orders/pending-payments';

  // Verify payment (admin only)
  static String verifyPayment(String orderId) =>
      '/orders/verify-payment/$orderId';

  // ==================== SHIPPING ENDPOINTS ====================
  static const String myDeliveries = '/shipping/my-deliveries';

  // Update shipping status
  static String updateShippingStatus(String orderId) =>
      '/shipping/update-status/$orderId';

  // ==================== NOTIFICATION ENDPOINTS ====================
  static const String notifications = '/notifications';
  static const String markAllRead = '/notifications/mark-all-read';
  static const String deleteMultipleNotifications =
      '/notifications/delete-multiple';

  // Delete single notification
  static String deleteNotification(String notificationId) =>
      '/notifications/$notificationId';
}
