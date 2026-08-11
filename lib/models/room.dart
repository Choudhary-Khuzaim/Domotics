import 'package:flutter/material.dart';

/// Represents a room/zone in the smart home.
class Room {
  final String name;
  final IconData icon;

  const Room({required this.name, required this.icon});
}

/// Pre-defined rooms used throughout the app.
class AppRooms {
  static const List<Room> all = [
    Room(name: 'All Rooms', icon: Icons.home_outlined),
    Room(name: 'Living Room', icon: Icons.weekend_outlined),
    Room(name: 'Bedroom', icon: Icons.bed_outlined),
    Room(name: 'Kitchen', icon: Icons.kitchen_outlined),
    Room(name: 'Outdoor', icon: Icons.park_outlined),
  ];
}
