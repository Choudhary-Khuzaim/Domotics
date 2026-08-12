import 'package:flutter/material.dart';

enum NotificationType { info, warning, success, security }

/// Notification / Activity Log entry model.
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final IconData icon;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.type = NotificationType.info,
    this.icon = Icons.info_outline,
    this.isRead = false,
  });
}
