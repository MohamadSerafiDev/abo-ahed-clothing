import 'package:abo_abed_clothing/core/api_links.dart';
import 'package:abo_abed_clothing/core/services/api_service.dart';
import 'package:abo_abed_clothing/models/notification_model.dart';

class NotificationApi {
  final ApiService _apiService;

  NotificationApi(this._apiService);

  /// Get all notifications for the current user
  Future<NotificationListResponseModel?> getNotifications() async {
    try {
      final response = await _apiService.getRequest(ApiLinks.notifications);

      if (response.statusCode == 200) {
        return NotificationListResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.error ?? 'Failed to fetch notifications');
      }
    } catch (e) {
      throw Exception('Failed to fetch notifications: ${e.toString()}');
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiService.patchRequest(ApiLinks.markAllRead, {});

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          response.error ?? 'Failed to mark notifications as read',
        );
      }
    } catch (e) {
      throw Exception('Failed to mark notifications as read: ${e.toString()}');
    }
  }

  /// Delete a single notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await _apiService.deleteRequest(
        ApiLinks.deleteNotification(notificationId),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.error ?? 'Failed to delete notification');
      }
    } catch (e) {
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }

  /// Delete multiple notifications
  Future<bool> deleteMultipleNotifications(List<String> notificationIds) async {
    try {
      final data = {'notificationIds': notificationIds};

      final response = await _apiService.postRequest(
        ApiLinks.deleteMultipleNotifications,
        data,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.error ?? 'Failed to delete notifications');
      }
    } catch (e) {
      throw Exception('Failed to delete notifications: ${e.toString()}');
    }
  }
}
