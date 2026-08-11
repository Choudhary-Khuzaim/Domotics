import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/energy_data.dart';

/// Manages energy analytics data and time filter state.
class EnergyProvider extends ChangeNotifier {
  TimeFilter _selectedFilter = TimeFilter.week;

  TimeFilter get selectedFilter => _selectedFilter;

  void setFilter(TimeFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  /// Returns usage data points for the currently selected time filter.
  List<EnergyDataPoint> get usageData {
    switch (_selectedFilter) {
      case TimeFilter.day:
        return _dayData;
      case TimeFilter.week:
        return _weekData;
      case TimeFilter.month:
        return _monthData;
      case TimeFilter.year:
        return _yearData;
    }
  }

  /// Device category breakdown — same across filters for simplicity.
  List<DeviceConsumption> get consumptionBreakdown => _breakdown;

  /// Total kWh for the current period.
  double get totalUsage =>
      usageData.fold(0.0, (sum, point) => sum + point.kWh);

  /// Rotating eco-tips.
  static const List<String> _tips = [
    'Schedule your AC to turn off 30 minutes before you leave. Save up to 15% on cooling costs!',
    'Switch to LED bulbs — they use 75% less energy than incandescent and last 25x longer.',
    'Unplug smart devices when not in use. Standby power accounts for 5-10% of residential energy use.',
    'Set your thermostat 2°C higher in summer. Each degree saves about 3% on your cooling bill.',
    'Use motion sensors for outdoor lights to avoid unnecessary energy waste at night.',
  ];

  int _tipIndex = 0;

  String get currentTip => _tips[_tipIndex % _tips.length];

  void nextTip() {
    _tipIndex++;
    notifyListeners();
  }

  // ─── Mock Data ────────────────────────────────────────────────

  static const List<EnergyDataPoint> _dayData = [
    EnergyDataPoint(label: '12AM', kWh: 0.8),
    EnergyDataPoint(label: '3AM', kWh: 0.5),
    EnergyDataPoint(label: '6AM', kWh: 1.2),
    EnergyDataPoint(label: '9AM', kWh: 2.8),
    EnergyDataPoint(label: '12PM', kWh: 3.5),
    EnergyDataPoint(label: '3PM', kWh: 4.2),
    EnergyDataPoint(label: '6PM', kWh: 3.8),
    EnergyDataPoint(label: '9PM', kWh: 2.5),
  ];

  static const List<EnergyDataPoint> _weekData = [
    EnergyDataPoint(label: 'Mon', kWh: 18.5),
    EnergyDataPoint(label: 'Tue', kWh: 22.3),
    EnergyDataPoint(label: 'Wed', kWh: 19.8),
    EnergyDataPoint(label: 'Thu', kWh: 24.1),
    EnergyDataPoint(label: 'Fri', kWh: 26.5),
    EnergyDataPoint(label: 'Sat', kWh: 28.2),
    EnergyDataPoint(label: 'Sun', kWh: 21.4),
  ];

  static const List<EnergyDataPoint> _monthData = [
    EnergyDataPoint(label: 'W1', kWh: 142.0),
    EnergyDataPoint(label: 'W2', kWh: 158.5),
    EnergyDataPoint(label: 'W3', kWh: 135.2),
    EnergyDataPoint(label: 'W4', kWh: 167.8),
  ];

  static const List<EnergyDataPoint> _yearData = [
    EnergyDataPoint(label: 'Jan', kWh: 580),
    EnergyDataPoint(label: 'Feb', kWh: 520),
    EnergyDataPoint(label: 'Mar', kWh: 490),
    EnergyDataPoint(label: 'Apr', kWh: 430),
    EnergyDataPoint(label: 'May', kWh: 510),
    EnergyDataPoint(label: 'Jun', kWh: 620),
    EnergyDataPoint(label: 'Jul', kWh: 680),
    EnergyDataPoint(label: 'Aug', kWh: 710),
    EnergyDataPoint(label: 'Sep', kWh: 630),
    EnergyDataPoint(label: 'Oct', kWh: 540),
    EnergyDataPoint(label: 'Nov', kWh: 490),
    EnergyDataPoint(label: 'Dec', kWh: 560),
  ];

  static final List<DeviceConsumption> _breakdown = [
    DeviceConsumption(
      category: 'HVAC',
      percentage: 45,
      color: AppColors.electricCyan,
      icon: Icons.ac_unit,
    ),
    DeviceConsumption(
      category: 'Lighting',
      percentage: 25,
      color: AppColors.accentAmber,
      icon: Icons.lightbulb_outline,
    ),
    DeviceConsumption(
      category: 'Entertainment',
      percentage: 20,
      color: AppColors.neonIndigo,
      icon: Icons.tv,
    ),
    DeviceConsumption(
      category: 'Security',
      percentage: 10,
      color: AppColors.accentRose,
      icon: Icons.lock_outline,
    ),
  ];
}
