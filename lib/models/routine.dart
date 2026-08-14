import 'package:flutter/material.dart';

/// Represents a scheduled automation routine.
class Routine {
  final String id;
  String name;
  String description;
  TimeOfDay time;
  List<int> days; // 1=Mon ... 7=Sun
  String? sceneId; // optional linked scene
  IconData icon;
  Color color;
  bool isEnabled;

  Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.days,
    this.sceneId,
    this.icon = Icons.schedule_rounded,
    this.color = const Color(0xFF06B6D4),
    this.isEnabled = true,
  });

  /// Returns human-readable day names for selected days.
  String get daysSummary {
    if (days.length == 7) return 'Every day';
    if (days.length == 5 &&
        days.contains(1) &&
        days.contains(2) &&
        days.contains(3) &&
        days.contains(4) &&
        days.contains(5)) {
      return 'Weekdays';
    }
    if (days.length == 2 && days.contains(6) && days.contains(7)) {
      return 'Weekends';
    }
    const names = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.map((d) => names[d]).join(', ');
  }

  /// Returns formatted time string.
  String get timeString {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
