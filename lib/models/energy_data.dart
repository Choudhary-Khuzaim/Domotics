import 'package:flutter/material.dart';

/// A single data point for time-series energy usage.
class EnergyDataPoint {
  final String label; // e.g., "Mon", "Jan", "6 AM"
  final double kWh;

  const EnergyDataPoint({required this.label, required this.kWh});
}

/// Energy consumption breakdown per device category.
class DeviceConsumption {
  final String category; // e.g., "HVAC", "Lighting"
  final double percentage; // 0 – 100
  final Color color;
  final IconData icon;

  const DeviceConsumption({
    required this.category,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

/// Time filter options for the analytics screen.
enum TimeFilter { day, week, month, year }
