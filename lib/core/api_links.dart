// ignore_for_file: constant_identifier_names

/// API Endpoints for Abu Abed Clothing Store
/// Base URL: http://192.168.59.55:5000/api
class ApiLinks {
  // Base URL
  static const String BASE_URL = 'http://192.168.1.110:5000/api';

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
  static const String allOrders = '/orders';
  static const String createOrder = '/orders';
  static const String activeOrders = '/orders/active';
  static const String ordersHistory = '/orders/history';
  static const String pendingPayments = '/orders/pending-payments';

  // Upload payment image (customer)
  static String uploadPaymentImage(String orderId) =>
      '/orders/upload-payment/$orderId';

  // Admin confirm order
  static String adminConfirmOrder(String orderId) =>
      '/orders/admin/confirm/$orderId';

  // Verify payment (admin only)
  static String verifyPayment(String orderId) =>
      '/orders/admin/verify-payment/$orderId';

  // Confirm delivery (admin/courier)
  static String confirmDelivery(String orderId) =>
      '/orders/delivery/confirm/$orderId';

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
