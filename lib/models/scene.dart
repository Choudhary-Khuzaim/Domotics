import 'package:flutter/material.dart';

/// Representation of an automated Smart Scene.
class SmartScene {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final List<Color> accentColors;
  bool isExecuting;

  SmartScene({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.accentColors,
    this.isExecuting = false,
  });
}
