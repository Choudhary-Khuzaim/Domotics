import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/routine.dart';

/// Manages scheduled home automation routines.
class RoutineProvider extends ChangeNotifier {
  final List<Routine> _routines = [
    Routine(
      id: 'routine_1',
      name: 'Morning Wake Up',
      description: 'Turn on lights, set AC to 24°C, start fan',
      time: const TimeOfDay(hour: 7, minute: 0),
      days: [1, 2, 3, 4, 5],
      sceneId: 'good_morning',
      icon: Icons.wb_sunny_rounded,
      color: const Color(0xFFF59E0B),
    ),
    Routine(
      id: 'routine_2',
      name: 'Bedtime',
      description: 'Turn off all lights, lock doors, set cozy temp',
      time: const TimeOfDay(hour: 23, minute: 0),
      days: [1, 2, 3, 4, 5, 6, 7],
      sceneId: 'good_night',
      icon: Icons.nightlight_round,
      color: const Color(0xFF8B5CF6),
    ),
    Routine(
      id: 'routine_3',
      name: 'Leave for Work',
      description: 'Arm security, lock doors, turn off devices',
      time: const TimeOfDay(hour: 8, minute: 30),
      days: [1, 2, 3, 4, 5],
      sceneId: 'away_mode',
      icon: Icons.directions_car_rounded,
      color: AppColors.accentGreen,
    ),
    Routine(
      id: 'routine_4',
      name: 'Friday Movie Night',
      description: 'Dim lights, turn on TV, set ambient purple',
      time: const TimeOfDay(hour: 20, minute: 0),
      days: [5],
      sceneId: 'movie_time',
      icon: Icons.movie_filter_rounded,
      color: AppColors.accentRose,
    ),
  ];

  List<Routine> get routines => List.unmodifiable(_routines);

  List<Routine> get enabledRoutines =>
      _routines.where((r) => r.isEnabled).toList();

  int get activeCount => _routines.where((r) => r.isEnabled).length;

  void addRoutine(Routine routine) {
    _routines.add(routine);
    notifyListeners();
  }

  void removeRoutine(String id) {
    _routines.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void toggleRoutine(String id) {
    final index = _routines.indexWhere((r) => r.id == id);
    if (index == -1) return;
    _routines[index].isEnabled = !_routines[index].isEnabled;
    notifyListeners();
  }

  void updateRoutine(Routine updated) {
    final index = _routines.indexWhere((r) => r.id == updated.id);
    if (index == -1) return;
    _routines[index] = updated;
    notifyListeners();
  }
}
