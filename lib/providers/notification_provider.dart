import 'package:flutter/material.dart';
import '../models/notification_model.dart';

/// Provider for managing home activity notifications and security logs.
class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'notif_1',
      title: 'Security Alert',
      message: 'Front door locked automatically at 10:00 PM',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      type: NotificationType.security,
      icon: Icons.shield_outlined,
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Smart Automation',
      message: '"Good Night" scene executed successfully',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      type: NotificationType.success,
      icon: Icons.auto_awesome_rounded,
    ),
    AppNotification(
      id: 'notif_3',
      title: 'Energy Peak Notice',
      message: 'AC usage reached peak efficiency target',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.info,
      icon: Icons.bolt_rounded,
    ),
    AppNotification(
      id: 'notif_4',
      title: 'Motion Detected',
      message: 'Motion sensor triggered near Garden Gate',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.warning,
      icon: Icons.motion_photos_on_rounded,
    ),
  ];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    IconData icon = Icons.notifications_none_rounded,
  }) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: message,
        timestamp: DateTime.now(),
        type: type,
        icon: icon,
      ),
    );
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
