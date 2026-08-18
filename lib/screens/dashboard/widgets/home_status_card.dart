import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/smart_device.dart';
import '../../../providers/device_provider.dart';

/// Compact home status card showing real-time device counts.
class HomeStatusCard extends StatelessWidget {
  const HomeStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final lights = deviceProvider.devices.whereType<SmartLight>().toList();
    final locks = deviceProvider.devices.whereType<SmartLock>().toList();
    final cameras = deviceProvider.devices.whereType<SmartCamera>().toList();
    final acs = deviceProvider.devices.whereType<SmartAC>().toList();

    final lightsOn = lights.where((l) => l.isActive).length;
    final locksLocked = locks.where((l) => l.isLocked).length;
    final camerasActive = cameras.where((c) => c.isActive).length;
    final avgTemp = acs.isEmpty
        ? 0
        : (acs.map((a) => a.temperature).reduce((a, b) => a + b) /
                acs.length)
            .round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDark
              ? AppColors.darkSurface.withOpacity(0.7)
              : AppColors.lightSurface.withOpacity(0.9),
          border: Border.all(
            color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
          ),
        ),
        child: Row(
          children: [
            _StatusItem(
              icon: Icons.lightbulb_rounded,
              value: '$lightsOn/${lights.length}',
              label: 'Lights',
              color: lightsOn > 0
                  ? AppColors.accentAmber
                  : isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
            ),
            _verticalDivider(isDark),
            _StatusItem(
              icon: Icons.lock_rounded,
              value: '$locksLocked/${locks.length}',
              label: 'Locked',
              color: locksLocked == locks.length
                  ? AppColors.accentGreen
                  : AppColors.accentAmber,
            ),
            _verticalDivider(isDark),
            _StatusItem(
              icon: Icons.videocam_rounded,
              value: '$camerasActive/${cameras.length}',
              label: 'Cameras',
              color: camerasActive == cameras.length
                  ? AppColors.accentGreen
                  : AppColors.accentAmber,
            ),
            _verticalDivider(isDark),
            _StatusItem(
              icon: Icons.thermostat_rounded,
              value: '$avgTemp°C',
              label: 'Avg Temp',
              color: AppColors.electricCyan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider(bool isDark) {
    return Container(
      width: 1,
      height: 30,
      color: isDark
          ? AppColors.glassBorder
          : AppColors.glassBorderLight,
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatusItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
