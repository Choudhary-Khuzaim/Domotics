import 'package:flutter/material.dart';
import '../models/smart_device.dart';
import '../models/device_activity.dart';

/// Manages the state of all smart devices across rooms.
class DeviceProvider extends ChangeNotifier {
  final List<SmartDevice> _devices = [
    // ─── Living Room ─────────────────────────────────────────────
    SmartLight(
      id: 'light_1',
      name: 'Ceiling Light',
      room: 'Living Room',
      isActive: true,
      isFavorite: true,
      brightness: 0.8,
      color: const Color(0xFFFFD700),
    ),
    SmartAC(
      id: 'ac_1',
      name: 'Air Conditioner',
      room: 'Living Room',
      isActive: true,
      temperature: 22,
      mode: ACMode.cool,
    ),
    SmartTV(
      id: 'tv_1',
      name: 'Samsung 4K TV',
      room: 'Living Room',
      isActive: true,
      volume: 0.45,
    ),
    SmartLock(
      id: 'lock_1',
      name: 'Front Door Lock',
      room: 'Living Room',
      isActive: true,
      isFavorite: true,
      isLocked: true,
    ),
    SmartSpeaker(
      id: 'speaker_1',
      name: 'Living Room Sonos',
      room: 'Living Room',
      isActive: true,
      currentTrack: 'Midnight City',
      artist: 'M83',
      isPlaying: true,
      volume: 0.6,
    ),
    SmartCamera(
      id: 'cam_1',
      name: 'Living Room Cam',
      room: 'Living Room',
      isActive: true,
      isFavorite: true,
      isNightVision: false,
      isMotionDetected: false,
      panAngle: 0,
    ),

    // ─── Bedroom ─────────────────────────────────────────────────
    SmartLight(
      id: 'light_2',
      name: 'Bedside Lamp',
      room: 'Bedroom',
      isActive: false,
      brightness: 0.4,
      color: const Color(0xFFFF6B6B),
    ),
    SmartAC(
      id: 'ac_2',
      name: 'Bedroom AC',
      room: 'Bedroom',
      isActive: true,
      temperature: 25,
      mode: ACMode.cool,
    ),
    SmartFan(
      id: 'fan_1',
      name: 'Ceiling Fan',
      room: 'Bedroom',
      isActive: true,
      speed: 3,
      isOscillating: true,
    ),
    SmartTV(
      id: 'tv_2',
      name: 'Bedroom TV',
      room: 'Bedroom',
      isActive: false,
      volume: 0.3,
    ),

    // ─── Kitchen ─────────────────────────────────────────────────
    SmartLight(
      id: 'light_3',
      name: 'Kitchen Lights',
      room: 'Kitchen',
      isActive: true,
      brightness: 1.0,
      color: const Color(0xFFFFFFFF),
    ),
    SmartLight(
      id: 'light_4',
      name: 'Under-Cabinet LED',
      room: 'Kitchen',
      isActive: false,
      brightness: 0.6,
      color: const Color(0xFF06B6D4),
    ),

    // ─── Outdoor ─────────────────────────────────────────────────
    SmartLight(
      id: 'light_5',
      name: 'Garden Lights',
      room: 'Outdoor',
      isActive: false,
      brightness: 0.5,
      color: const Color(0xFF22C55E),
    ),
    SmartLock(
      id: 'lock_2',
      name: 'Gate Lock',
      room: 'Outdoor',
      isActive: true,
      isLocked: true,
    ),
    SmartCamera(
      id: 'cam_2',
      name: 'Garden Security Cam',
      room: 'Outdoor',
      isActive: true,
      isNightVision: true,
      isMotionDetected: true,
      panAngle: 15,
    ),
  ];

  // ─── Activity Log ─────────────────────────────────────────────
  final List<DeviceActivity> _activityLog = [
    DeviceActivity(
      id: 'act_1',
      deviceId: 'light_1',
      action: 'Turned On',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      details: 'Brightness set to 80%',
      icon: Icons.lightbulb_rounded,
      color: const Color(0xFFFFD700),
    ),
    DeviceActivity(
      id: 'act_2',
      deviceId: 'lock_1',
      action: 'Door Locked',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      details: 'Auto-lock triggered',
      icon: Icons.lock_rounded,
      color: const Color(0xFF22C55E),
    ),
    DeviceActivity(
      id: 'act_3',
      deviceId: 'ac_1',
      action: 'Temperature Changed',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      details: 'Set to 22°C (Cool mode)',
      icon: Icons.thermostat_rounded,
      color: const Color(0xFF06B6D4),
    ),
    DeviceActivity(
      id: 'act_4',
      deviceId: 'cam_1',
      action: 'Motion Detected',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      details: 'Living room area',
      icon: Icons.motion_photos_on_rounded,
      color: const Color(0xFFF59E0B),
    ),
    DeviceActivity(
      id: 'act_5',
      deviceId: 'speaker_1',
      action: 'Now Playing',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      details: 'Midnight City — M83',
      icon: Icons.music_note_rounded,
      color: const Color(0xFF8B5CF6),
    ),
    DeviceActivity(
      id: 'act_6',
      deviceId: 'tv_1',
      action: 'Turned On',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      details: 'Volume at 45%',
      icon: Icons.tv_rounded,
      color: const Color(0xFF6366F1),
    ),
    DeviceActivity(
      id: 'act_7',
      deviceId: 'cam_2',
      action: 'Night Vision Enabled',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      details: 'Auto-triggered at sunset',
      icon: Icons.nightlight_rounded,
      color: const Color(0xFF8B5CF6),
    ),
    DeviceActivity(
      id: 'act_8',
      deviceId: 'lock_1',
      action: 'Door Unlocked',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      details: 'Manual unlock via app',
      icon: Icons.lock_open_rounded,
      color: const Color(0xFFF59E0B),
    ),
    DeviceActivity(
      id: 'act_9',
      deviceId: 'fan_1',
      action: 'Speed Changed',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      details: 'Set to Speed 3',
      icon: Icons.air_rounded,
      color: const Color(0xFF06B6D4),
    ),
    DeviceActivity(
      id: 'act_10',
      deviceId: 'light_1',
      action: 'Color Changed',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      details: 'Warm Gold (#FFD700)',
      icon: Icons.palette_rounded,
      color: const Color(0xFFF43F5E),
    ),
  ];

  List<SmartDevice> get devices => _devices;

  int get activeDeviceCount => _devices.where((d) => d.isActive).length;

  /// Favorite devices getter.
  List<SmartDevice> get favorites =>
      _devices.where((d) => d.isFavorite).toList();

  /// Get all activity logs.
  List<DeviceActivity> get activityLog => List.unmodifiable(_activityLog);

  /// Get activities for a specific device.
  List<DeviceActivity> getDeviceActivities(String deviceId) {
    return _activityLog.where((a) => a.deviceId == deviceId).toList();
  }

  /// Add activity log entry.
  void _addActivity({
    required String deviceId,
    required String action,
    String details = '',
    IconData icon = Icons.info_outline,
    Color color = const Color(0xFF06B6D4),
  }) {
    _activityLog.insert(
      0,
      DeviceActivity(
        id: 'act_${DateTime.now().millisecondsSinceEpoch}',
        deviceId: deviceId,
        action: action,
        timestamp: DateTime.now(),
        details: details,
        icon: icon,
        color: color,
      ),
    );
  }

  /// Call notifyListeners manually after batch operations.
  void refresh() {
    notifyListeners();
  }

  /// Get devices filtered by room name. "All Rooms" returns everything.
  List<SmartDevice> getDevicesByRoom(String room) {
    if (room == 'All Rooms') return _devices;
    return _devices.where((d) => d.room == room).toList();
  }

  /// Find a device by its ID.
  SmartDevice? getDeviceById(String id) {
    try {
      return _devices.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Toggle favorite status for a device.
  void toggleFavorite(String id) {
    final device = getDeviceById(id);
    if (device != null) {
      device.isFavorite = !device.isFavorite;
      notifyListeners();
    }
  }

  /// Master switch: Turn off all lights in home.
  void turnOffAllLights() {
    for (var d in _devices.whereType<SmartLight>()) {
      d.isActive = false;
    }
    _addActivity(
      deviceId: 'all',
      action: 'All Lights Off',
      details: 'Master switch triggered',
      icon: Icons.lightbulb_outline,
      color: const Color(0xFFF59E0B),
    );
    notifyListeners();
  }

  /// Master switch: Lock all door locks in home.
  void lockAllDoors() {
    for (var d in _devices.whereType<SmartLock>()) {
      d.isActive = true;
      d.isLocked = true;
    }
    _addActivity(
      deviceId: 'all',
      action: 'All Doors Locked',
      details: 'Master switch triggered',
      icon: Icons.lock_rounded,
      color: const Color(0xFF22C55E),
    );
    notifyListeners();
  }

  /// Master switch: Activate Away Mode.
  void activateAwayMode() {
    for (var d in _devices) {
      if (d is SmartLight || d is SmartTV || d is SmartSpeaker) {
        d.isActive = false;
      }
      if (d is SmartLock) {
        d.isActive = true;
        d.isLocked = true;
      }
      if (d is SmartCamera) {
        d.isActive = true;
        d.isMotionDetected = true;
      }
    }
    notifyListeners();
  }

  /// Master switch: Activate Night Mode.
  void activateNightMode() {
    for (var d in _devices) {
      if (d is SmartLight || d is SmartTV || d is SmartSpeaker) {
        d.isActive = false;
      }
      if (d is SmartLock) {
        d.isActive = true;
        d.isLocked = true;
      }
      if (d is SmartAC) {
        d.isActive = true;
        d.temperature = 24;
      }
    }
    notifyListeners();
  }

  /// Master switch: Activate Party Mode.
  void activatePartyMode() {
    for (var d in _devices) {
      if (d is SmartLight) {
        d.isActive = true;
        d.brightness = 1.0;
        d.color = const Color(0xFFF43F5E); // Accent Rose
      }
      if (d is SmartSpeaker) {
        d.isActive = true;
        d.isPlaying = true;
        d.volume = 0.9;
      }
    }
    notifyListeners();
  }

  /// Toggle a device on/off.
  void toggleDevice(String id) {
    final device = getDeviceById(id);
    if (device != null) {
      device.isActive = !device.isActive;
      _addActivity(
        deviceId: id,
        action: device.isActive ? 'Turned On' : 'Turned Off',
        details: '${device.name} in ${device.room}',
        icon: device.isActive
            ? Icons.power_settings_new_rounded
            : Icons.power_off_rounded,
        color: device.isActive
            ? const Color(0xFF22C55E)
            : const Color(0xFFF43F5E),
      );
      notifyListeners();
    }
  }

  /// Update brightness for a SmartLight.
  void updateBrightness(String id, double value) {
    final device = getDeviceById(id);
    if (device is SmartLight) {
      device.brightness = value;
      _addActivity(
        deviceId: id,
        action: 'Brightness Changed',
        details: '${(value * 100).round()}%',
        icon: Icons.brightness_6_rounded,
        color: const Color(0xFFF59E0B),
      );
      notifyListeners();
    }
  }

  /// Update color for a SmartLight.
  void updateLightColor(String id, Color color) {
    final device = getDeviceById(id);
    if (device is SmartLight) {
      device.color = color;
      _addActivity(
        deviceId: id,
        action: 'Color Changed',
        details: '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
        icon: Icons.palette_rounded,
        color: const Color(0xFFF43F5E),
      );
      notifyListeners();
    }
  }

  /// Update temperature for a SmartAC.
  void updateTemperature(String id, int temp) {
    final device = getDeviceById(id);
    if (device is SmartAC) {
      device.temperature = temp.clamp(16, 30);
      _addActivity(
        deviceId: id,
        action: 'Temperature Changed',
        details: 'Set to $temp°C',
        icon: Icons.thermostat_rounded,
        color: const Color(0xFF06B6D4),
      );
      notifyListeners();
    }
  }

  /// Update AC mode.
  void updateACMode(String id, ACMode mode) {
    final device = getDeviceById(id);
    if (device is SmartAC) {
      device.mode = mode;
      _addActivity(
        deviceId: id,
        action: 'Mode Changed',
        details: mode.name[0].toUpperCase() + mode.name.substring(1),
        icon: Icons.ac_unit_rounded,
        color: const Color(0xFF06B6D4),
      );
      notifyListeners();
    }
  }

  /// Toggle smart lock.
  void toggleLock(String id) {
    final device = getDeviceById(id);
    if (device is SmartLock) {
      device.isLocked = !device.isLocked;
      _addActivity(
        deviceId: id,
        action: device.isLocked ? 'Door Locked' : 'Door Unlocked',
        details: device.name,
        icon: device.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
        color: device.isLocked
            ? const Color(0xFF22C55E)
            : const Color(0xFFF59E0B),
      );
      notifyListeners();
    }
  }

  /// Update TV or Speaker volume.
  void updateVolume(String id, double volume) {
    final device = getDeviceById(id);
    if (device is SmartTV) {
      device.volume = volume.clamp(0.0, 1.0);
      notifyListeners();
    } else if (device is SmartSpeaker) {
      device.volume = volume.clamp(0.0, 1.0);
      notifyListeners();
    }
  }

  /// Update Fan speed (1-5).
  void updateFanSpeed(String id, int speed) {
    final device = getDeviceById(id);
    if (device is SmartFan) {
      device.speed = speed.clamp(1, 5);
      _addActivity(
        deviceId: id,
        action: 'Speed Changed',
        details: 'Set to Speed $speed',
        icon: Icons.air_rounded,
        color: const Color(0xFF06B6D4),
      );
      notifyListeners();
    }
  }

  /// Toggle Fan oscillation.
  void toggleFanOscillation(String id) {
    final device = getDeviceById(id);
    if (device is SmartFan) {
      device.isOscillating = !device.isOscillating;
      notifyListeners();
    }
  }

  /// Toggle Camera Night Vision mode.
  void toggleCameraNightVision(String id) {
    final device = getDeviceById(id);
    if (device is SmartCamera) {
      device.isNightVision = !device.isNightVision;
      _addActivity(
        deviceId: id,
        action: device.isNightVision
            ? 'Night Vision Enabled'
            : 'Night Vision Disabled',
        details: device.name,
        icon: Icons.nightlight_rounded,
        color: const Color(0xFF8B5CF6),
      );
      notifyListeners();
    }
  }

  /// Adjust Camera Pan Angle (-90 to +90).
  void adjustCameraPan(String id, int delta) {
    final device = getDeviceById(id);
    if (device is SmartCamera) {
      device.panAngle = (device.panAngle + delta).clamp(-90, 90);
      notifyListeners();
    }
  }

  /// Toggle Speaker play/pause.
  void toggleSpeakerPlay(String id) {
    final device = getDeviceById(id);
    if (device is SmartSpeaker) {
      device.isPlaying = !device.isPlaying;
      _addActivity(
        deviceId: id,
        action: device.isPlaying ? 'Playback Started' : 'Playback Paused',
        details: '${device.currentTrack} — ${device.artist}',
        icon: device.isPlaying
            ? Icons.play_circle_rounded
            : Icons.pause_circle_rounded,
        color: const Color(0xFF8B5CF6),
      );
      notifyListeners();
    }
  }

  /// Add a new device to the home.
  void addDevice(SmartDevice device) {
    _devices.add(device);
    _addActivity(
      deviceId: device.id,
      action: 'Device Added',
      details: '${device.name} added to ${device.room}',
      icon: Icons.add_circle_rounded,
      color: const Color(0xFF22C55E),
    );
    notifyListeners();
  }

  /// Remove a device by its ID.
  void removeDevice(String id) {
    final device = getDeviceById(id);
    final name = device?.name ?? 'Unknown';
    _devices.removeWhere((d) => d.id == id);
    _addActivity(
      deviceId: id,
      action: 'Device Removed',
      details: '$name removed from home',
      icon: Icons.remove_circle_rounded,
      color: const Color(0xFFF43F5E),
    );
    notifyListeners();
  }
}
