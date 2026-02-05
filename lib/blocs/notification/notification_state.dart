import 'package:abo_abed_clothing/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationsLoaded(this.notifications, this.unreadCount);
}

class NotificationSuccess extends NotificationState {
  final String message;

  NotificationSuccess(this.message);
}

class NotificationFailure extends NotificationState {
  final String error;

  NotificationFailure(this.error);
}
