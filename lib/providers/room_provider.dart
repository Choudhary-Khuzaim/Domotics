import 'package:flutter/material.dart';
import '../models/room.dart';

/// Manages the dynamic list of rooms in the smart home.
class RoomProvider extends ChangeNotifier {
  final List<Room> _rooms = [
    const Room(name: 'Living Room', icon: Icons.weekend_outlined),
    const Room(name: 'Bedroom', icon: Icons.bed_outlined),
    const Room(name: 'Kitchen', icon: Icons.kitchen_outlined),
    const Room(name: 'Outdoor', icon: Icons.park_outlined),
  ];

  List<Room> get rooms => List.unmodifiable(_rooms);

  /// All room names including 'All Rooms' for filter use.
  List<String> get roomNames => ['All Rooms', ..._rooms.map((r) => r.name)];

  /// Available icons for room creation.
  static const List<IconData> availableIcons = [
    Icons.weekend_outlined,
    Icons.bed_outlined,
    Icons.kitchen_outlined,
    Icons.park_outlined,
    Icons.bathtub_outlined,
    Icons.garage_outlined,
    Icons.stairs_outlined,
    Icons.child_care_outlined,
    Icons.work_outline,
    Icons.fitness_center_outlined,
    Icons.local_laundry_service_outlined,
    Icons.balcony_outlined,
    Icons.dining_outlined,
    Icons.meeting_room_outlined,
    Icons.warehouse_outlined,
    Icons.roofing_outlined,
  ];

  void addRoom(String name, IconData icon) {
    if (name.trim().isEmpty) return;
    if (_rooms.any((r) => r.name.toLowerCase() == name.toLowerCase())) return;
    _rooms.add(Room(name: name.trim(), icon: icon));
    notifyListeners();
  }

  void removeRoom(String name) {
    _rooms.removeWhere((r) => r.name == name);
    notifyListeners();
  }

  void updateRoom(String oldName, String newName, IconData icon) {
    final index = _rooms.indexWhere((r) => r.name == oldName);
    if (index == -1) return;
    _rooms[index] = Room(name: newName.trim(), icon: icon);
    notifyListeners();
  }
}
