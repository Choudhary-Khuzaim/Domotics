import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/device_provider.dart';
import '../../../providers/notification_provider.dart';

/// Quick Master Action Controls for home-wide management.
class MasterControlsCard extends StatelessWidget {
  const MasterControlsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.read<DeviceProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Turn Off All Lights Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                deviceProvider.turnOffAllLights();
                notificationProvider.addNotification(
                  title: 'Master Action Executed',
                  message: 'All home lights turned off',
                  icon: Icons.lightbulb_outline,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All lights turned off'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  border: Border.all(
                    color: isDark
                        ? AppColors.glassBorder
                        : AppColors.glassBorderLight,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lightbulb_outlined,
                        size: 18, color: AppColors.accentAmber),
                    SizedBox(width: 8),
                    Text(
                      'Off All Lights',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Lock All Doors Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                deviceProvider.lockAllDoors();
                notificationProvider.addNotification(
                  title: 'Master Action Executed',
                  message: 'All door locks locked',
                  icon: Icons.lock_outline,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All doors locked'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  border: Border.all(
                    color: isDark
                        ? AppColors.glassBorder
                        : AppColors.glassBorderLight,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded,
                        size: 18, color: AppColors.accentGreen),
                    SizedBox(width: 8),
                    Text(
                      'Lock All Doors',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
