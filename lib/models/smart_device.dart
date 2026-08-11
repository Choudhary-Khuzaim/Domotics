import 'package:flutter/material.dart';

/// Types of smart devices supported in the app.
enum DeviceType { light, ac, lock, tv }

/// Base model for all smart home devices.
class SmartDevice {
  final String id;
  final String name;
  final String room;
  final DeviceType type;
  final IconData icon;
  bool isActive;

  SmartDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    required this.icon,
    this.isActive = false,
  });
}

/// Smart RGB Light with brightness and color control.
class SmartLight extends SmartDevice {
  double brightness; // 0.0 – 1.0
  Color color;

  SmartLight({
    required super.id,
    required super.name,
    required super.room,
    super.isActive,
    this.brightness = 0.7,
    this.color = const Color(0xFFFFD700),
  }) : super(
         type: DeviceType.light,
         icon: Icons.lightbulb_outline,
       );
}

/// AC mode options.
enum ACMode { cool, heat, fan }

/// Smart Air Conditioner with temperature and mode control.
class SmartAC extends SmartDevice {
  int temperature; // 16 – 30 °C
  ACMode mode;

  SmartAC({
    required super.id,
    required super.name,
    required super.room,
    super.isActive,
    this.temperature = 24,
    this.mode = ACMode.cool,
  }) : super(
         type: DeviceType.ac,
         icon: Icons.ac_unit,
       );
}

/// Smart Lock with lock/unlock state.
class SmartLock extends SmartDevice {
  bool isLocked;

  SmartLock({
    required super.id,
    required super.name,
    required super.room,
    super.isActive,
    this.isLocked = true,
  }) : super(
         type: DeviceType.lock,
         icon: Icons.lock_outline,
       );
}

/// Smart TV with volume control.
class SmartTV extends SmartDevice {
  double volume; // 0.0 – 1.0

  SmartTV({
    required super.id,
    required super.name,
    required super.room,
    super.isActive,
    this.volume = 0.5,
  }) : super(
         type: DeviceType.tv,
         icon: Icons.tv,
       );
}
