import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/scene.dart';
import '../models/smart_device.dart';
import 'device_provider.dart';
import 'notification_provider.dart';

/// Provider for managing and executing automated Smart Scenes.
class SceneProvider extends ChangeNotifier {
  final List<SmartScene> _scenes = [
    SmartScene(
      id: 'good_night',
      name: 'Good Night',
      description: 'Turns off all lights, locks all doors & sets cozy AC temp',
      icon: Icons.nightlight_round,
      gradient: const LinearGradient(
        colors: [Color(0xFF311B92), Color(0xFF4A148C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColors: const [Color(0xFF8E24AA), Color(0xFFD81B60)],
    ),
    SmartScene(
      id: 'movie_time',
      name: 'Movie Time',
      description: 'Dims lights to 20% purple hue & powers on main TV',
      icon: Icons.movie_filter_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF880E4F), Color(0xFF4A148C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColors: const [Color(0xFFE91E63), Color(0xFF9C27B0)],
    ),
    SmartScene(
      id: 'away_mode',
      name: 'Away Mode',
      description: 'Locks all doors, turns off devices & arms security cameras',
      icon: Icons.security_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF004D40)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColors: const [Color(0xFF2E7D32), Color(0xFF00695C)],
    ),
    SmartScene(
      id: 'good_morning',
      name: 'Good Morning',
      description: 'Turns on ambient lights, sets AC to 24°C & starts fan',
      icon: Icons.wb_sunny_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFE65100), Color(0xFFF57F17)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accentColors: const [AppColors.accentAmber, Color(0xFFFF9800)],
    ),
  ];

  List<SmartScene> get scenes => List.unmodifiable(_scenes);

  /// Trigger execution of a Smart Scene.
  Future<void> executeScene({
    required String sceneId,
    required DeviceProvider deviceProvider,
    required NotificationProvider notificationProvider,
  }) async {
    final sceneIndex = _scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex == -1) return;

    _scenes[sceneIndex].isExecuting = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    switch (sceneId) {
      case 'good_night':
        // Turn off lights, TV, speaker & fans, lock doors, set cozy AC temp
        for (var device in deviceProvider.devices) {
          if (device is SmartLight) {
            device.isActive = false;
          } else if (device is SmartLock) {
            device.isActive = true;
            device.isLocked = true;
          } else if (device is SmartAC) {
            device.isActive = true;
            device.temperature = 22;
            device.mode = ACMode.cool;
          } else if (device is SmartTV) {
            device.isActive = false;
          } else if (device is SmartSpeaker) {
            device.isActive = false;
            device.isPlaying = false;
          } else if (device is SmartFan) {
            device.isActive = false;
          }
        }
        notificationProvider.addNotification(
          title: 'Good Night Activated',
          message: 'All lights turned off, doors locked & AC set to 22°C',
          icon: Icons.nightlight_round,
        );
        break;

      case 'movie_time':
        for (var device in deviceProvider.devices) {
          if (device is SmartLight && device.room == 'Living Room') {
            device.isActive = true;
            device.brightness = 0.2;
            device.color = const Color(0xFF9C27B0);
          } else if (device is SmartTV && device.room == 'Living Room') {
            device.isActive = true;
          }
        }
        notificationProvider.addNotification(
          title: 'Movie Time Activated',
          message: 'Living room ambient purple lighting set & TV turned on',
          icon: Icons.movie_filter_rounded,
        );
        break;

      case 'away_mode':
        for (var device in deviceProvider.devices) {
          if (device is SmartLock) {
            device.isActive = true;
            device.isLocked = true;
          } else if (device is SmartCamera) {
            device.isActive = true;
            device.isMotionDetected = true;
            device.isNightVision = true;
          } else if (device is! SmartCamera && device is! SmartLock) {
            device.isActive = false;
          }
        }
        notificationProvider.addNotification(
          title: 'Away Mode Armed',
          message: 'Security cameras armed, all doors locked & power off',
          icon: Icons.security_rounded,
        );
        break;

      case 'good_morning':
        for (var device in deviceProvider.devices) {
          if (device is SmartLight && (device.room == 'Living Room' || device.room == 'Kitchen')) {
            device.isActive = true;
            device.brightness = 0.8;
            device.color = const Color(0xFFFFD700);
          } else if (device is SmartAC) {
            device.isActive = true;
            device.temperature = 24;
          } else if (device is SmartFan) {
            device.isActive = true;
            device.speed = 3;
          }
        }
        notificationProvider.addNotification(
          title: 'Good Morning Activated',
          message: 'Warm morning lights turned on & AC set to 24°C',
          icon: Icons.wb_sunny_rounded,
        );
        break;
    }

    deviceProvider.refresh();
    _scenes[sceneIndex].isExecuting = false;
    notifyListeners();
  }
}
