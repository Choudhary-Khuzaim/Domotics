import 'package:flutter/material.dart';

/// Represents a single activity log entry for a device.
class DeviceActivity {
  final String id;
  final String deviceId;
  final String action;
  final DateTime timestamp;
  final String details;
  final IconData icon;
  final Color color;

  DeviceActivity({
    required this.id,
    required this.deviceId,
    required this.action,
    required this.timestamp,
    this.details = '',
    this.icon = Icons.info_outline,
    this.color = const Color(0xFF06B6D4),
  });

  /// Returns a human-readable relative time string.
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
