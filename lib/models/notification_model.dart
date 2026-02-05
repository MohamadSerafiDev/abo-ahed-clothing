class NotificationModel {
  final String id;
  final String userId;
  final String message;
  final String type; // 'order', 'payment', 'delivery', 'general'
  final bool isRead;
  final Map<String, dynamic>? data; // Additional data
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.isRead,
    this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user'] ?? json['userId'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      isRead: json['isRead'] ?? false,
      data: json['data'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'message': message,
      'type': type,
      'isRead': isRead,
      if (data != null) 'data': data,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? message,
    String? type,
    bool? isRead,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper to mark as read
  NotificationModel markAsRead() {
    return copyWith(isRead: true);
  }
}

class NotificationListResponseModel {
  final List<NotificationModel> notifications;
  final int total;
  final int unreadCount;

  NotificationListResponseModel({
    required this.notifications,
    required this.total,
    required this.unreadCount,
  });

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
    final notifications = json['notifications'] != null
        ? (json['notifications'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList()
        : <NotificationModel>[];

    return NotificationListResponseModel(
      notifications: notifications,
      total: json['total'] ?? notifications.length,
      unreadCount:
          json['unreadCount'] ?? notifications.where((n) => !n.isRead).length,
    );
  }
}
