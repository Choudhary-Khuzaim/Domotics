import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/room.dart';

/// Horizontal scrollable room filter tabs.
class RoomTabs extends StatelessWidget {
  final String selectedRoom;
  final ValueChanged<String> onRoomSelected;

  const RoomTabs({
    super.key,
    required this.selectedRoom,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppRooms.all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final room = AppRooms.all[index];
          final isSelected = selectedRoom == room.name;

          return GestureDetector(
            onTap: () => onRoomSelected(room.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isSelected
                    ? AppColors.electricCyan.withOpacity(isDark ? 0.15 : 0.12)
                    : isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                border: Border.all(
                  color: isSelected
                      ? AppColors.electricCyan.withOpacity(0.5)
                      : isDark
                          ? AppColors.glassBorder
                          : AppColors.glassBorderLight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    room.icon,
                    size: 16,
                    color: isSelected
                        ? AppColors.electricCyan
                        : isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    room.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.electricCyan
                          : isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
