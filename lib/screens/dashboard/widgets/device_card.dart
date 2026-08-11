import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/smart_device.dart';
import '../../../providers/device_provider.dart';
import '../../../widgets/animated_toggle.dart';
import '../../../widgets/glass_card.dart';

/// A device control card for the dashboard grid.
/// Displays device info, toggle, and type-specific inline controls.
class DeviceCard extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback? onTap;

  const DeviceCard({super.key, required this.device, this.onTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DeviceProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      isActive: device.isActive,
      activeGlowColor: _getAccentColor(),
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Toggle row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Device icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: device.isActive
                      ? _getAccentColor().withOpacity(0.15)
                      : isDark
                          ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                          : AppColors.lightSurfaceVariant,
                ),
                child: Icon(
                  _getDeviceIcon(),
                  size: 22,
                  color: device.isActive
                      ? _getAccentColor()
                      : isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                ),
              ),
              AnimatedToggle(
                value: device.isActive,
                activeColor: _getAccentColor(),
                onChanged: (_) => provider.toggleDevice(device.id),
              ),
            ],
          ),

          const Spacer(),

          // Device name
          Text(
            device.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Room name
          Text(
            device.room,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 10),

          // Type-specific controls
          _buildInlineControl(context, provider),
        ],
      ),
    );
  }

  Widget _buildInlineControl(BuildContext context, DeviceProvider provider) {
    if (!device.isActive) {
      return Text(
        'Off',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextMuted
              : AppColors.lightTextMuted,
        ),
      );
    }

    switch (device.type) {
      case DeviceType.light:
        final light = device as SmartLight;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.brightness_6, size: 13, color: _getAccentColor()),
                const SizedBox(width: 4),
                Text(
                  '${(light.brightness * 100).round()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getAccentColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                  activeTrackColor: _getAccentColor(),
                  thumbColor: _getAccentColor(),
                ),
                child: Slider(
                  value: light.brightness,
                  onChanged: (v) => provider.updateBrightness(device.id, v),
                ),
              ),
            ),
          ],
        );

      case DeviceType.ac:
        final ac = device as SmartAC;
        return Row(
          children: [
            _tempButton(
              context,
              Icons.remove,
              () => provider.updateTemperature(device.id, ac.temperature - 1),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '${ac.temperature}°C',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _getAccentColor(),
                  ),
                ),
              ),
            ),
            _tempButton(
              context,
              Icons.add,
              () => provider.updateTemperature(device.id, ac.temperature + 1),
            ),
          ],
        );

      case DeviceType.lock:
        final lock = device as SmartLock;
        return Row(
          children: [
            Icon(
              lock.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
              size: 16,
              color: lock.isLocked
                  ? AppColors.accentGreen
                  : AppColors.accentRose,
            ),
            const SizedBox(width: 6),
            Text(
              lock.isLocked ? 'Locked' : 'Unlocked',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: lock.isLocked
                    ? AppColors.accentGreen
                    : AppColors.accentRose,
              ),
            ),
          ],
        );

      case DeviceType.tv:
        final tv = device as SmartTV;
        return Row(
          children: [
            Icon(Icons.volume_up_rounded, size: 14, color: _getAccentColor()),
            const SizedBox(width: 6),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: tv.volume,
                  minHeight: 4,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  valueColor: AlwaysStoppedAnimation(_getAccentColor()),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${(tv.volume * 100).round()}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getAccentColor(),
              ),
            ),
          ],
        );
    }
  }

  Widget _tempButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDark
              ? AppColors.darkSurfaceVariant.withOpacity(0.5)
              : AppColors.lightSurfaceVariant,
        ),
        child: Icon(icon, size: 14, color: _getAccentColor()),
      ),
    );
  }

  Color _getAccentColor() {
    switch (device.type) {
      case DeviceType.light:
        return AppColors.accentAmber;
      case DeviceType.ac:
        return AppColors.electricCyan;
      case DeviceType.lock:
        return AppColors.accentGreen;
      case DeviceType.tv:
        return AppColors.neonIndigo;
    }
  }

  IconData _getDeviceIcon() {
    if (!device.isActive) return device.icon;
    switch (device.type) {
      case DeviceType.light:
        return Icons.lightbulb_rounded;
      case DeviceType.ac:
        return Icons.ac_unit_rounded;
      case DeviceType.lock:
        final lock = device as SmartLock;
        return lock.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded;
      case DeviceType.tv:
        return Icons.tv_rounded;
    }
  }
}
