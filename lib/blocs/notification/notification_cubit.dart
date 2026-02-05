import 'package:abo_abed_clothing/core/apis/notification/notification_api.dart';
import 'package:abo_abed_clothing/blocs/notification/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationApi _notificationService;

  NotificationCubit(this._notificationService) : super(NotificationInitial());

  /// Get all notifications
  Future<void> getNotifications() async {
    emit(NotificationLoading());
    try {
      final response = await _notificationService.getNotifications();
      if (response != null) {
        emit(NotificationsLoaded(response.notifications, response.unreadCount));
      } else {
        emit(NotificationFailure('Failed to load notifications'));
      }
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    emit(NotificationLoading());
    try {
      final success = await _notificationService.markAllAsRead();
      if (success) {
        emit(NotificationSuccess('All notifications marked as read'));
        // Reload notifications
        await getNotifications();
      } else {
        emit(NotificationFailure('Failed to mark as read'));
      }
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  /// Delete a single notification
  Future<void> deleteNotification(String notificationId) async {
    emit(NotificationLoading());
    try {
      final success = await _notificationService.deleteNotification(
        notificationId,
      );
      if (success) {
        emit(NotificationSuccess('Notification deleted'));
        // Reload notifications
        await getNotifications();
      } else {
        emit(NotificationFailure('Failed to delete notification'));
      }
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  /// Delete multiple notifications
  Future<void> deleteMultipleNotifications(List<String> notificationIds) async {
    emit(NotificationLoading());
    try {
      final success = await _notificationService.deleteMultipleNotifications(
        notificationIds,
      );
      if (success) {
        emit(NotificationSuccess('Notifications deleted'));
        // Reload notifications
        await getNotifications();
      } else {
        emit(NotificationFailure('Failed to delete notifications'));
      }
    } catch (e) {
      emit(NotificationFailure(e.toString()));
    }
  }

  /// Reset state
  void reset() {
    emit(NotificationInitial());
  }
}
