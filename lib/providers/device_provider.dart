import 'package:flutter/material.dart';
import '../models/smart_device.dart';

/// Manages the state of all smart devices across rooms.
class DeviceProvider extends ChangeNotifier {
  final List<SmartDevice> _devices = [
    // ─── Living Room ─────────────────────────────────────────────
    SmartLight(
      id: 'light_1',
      name: 'Ceiling Light',
      room: 'Living Room',
      isActive: true,
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

  List<SmartDevice> get devices => _devices;

  int get activeDeviceCount => _devices.where((d) => d.isActive).length;

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

  /// Master switch: Turn off all lights in home.
  void turnOffAllLights() {
    for (var d in _devices.whereType<SmartLight>()) {
      d.isActive = false;
    }
    notifyListeners();
  }

  /// Master switch: Lock all door locks in home.
  void lockAllDoors() {
    for (var d in _devices.whereType<SmartLock>()) {
      d.isActive = true;
      d.isLocked = true;
    }
    notifyListeners();
  }

  /// Toggle a device on/off.
  void toggleDevice(String id) {
    final device = getDeviceById(id);
    if (device != null) {
      device.isActive = !device.isActive;
      notifyListeners();
    }
  }

  /// Update brightness for a SmartLight.
  void updateBrightness(String id, double value) {
    final device = getDeviceById(id);
    if (device is SmartLight) {
      device.brightness = value;
      notifyListeners();
    }
  }

  /// Update color for a SmartLight.
  void updateLightColor(String id, Color color) {
    final device = getDeviceById(id);
    if (device is SmartLight) {
      device.color = color;
      notifyListeners();
    }
  }

  /// Update temperature for a SmartAC.
  void updateTemperature(String id, int temp) {
    final device = getDeviceById(id);
    if (device is SmartAC) {
      device.temperature = temp.clamp(16, 30);
      notifyListeners();
    }
  }

  /// Update AC mode.
  void updateACMode(String id, ACMode mode) {
    final device = getDeviceById(id);
    if (device is SmartAC) {
      device.mode = mode;
      notifyListeners();
    }
  }

  /// Toggle smart lock.
  void toggleLock(String id) {
    final device = getDeviceById(id);
    if (device is SmartLock) {
      device.isLocked = !device.isLocked;
      notifyListeners();
    }
  }

  /// Update TV volume.
  void updateVolume(String id, double volume) {
    final device = getDeviceById(id);
    if (device is SmartTV) {
      device.volume = volume.clamp(0.0, 1.0);
      notifyListeners();
    }
  }

  /// Update Fan speed (1-5).
  void updateFanSpeed(String id, int speed) {
    final device = getDeviceById(id);
    if (device is SmartFan) {
      device.speed = speed.clamp(1, 5);
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
      notifyListeners();
    }
  }

}
