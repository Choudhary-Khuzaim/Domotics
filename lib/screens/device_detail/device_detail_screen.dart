import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/smart_device.dart';
import '../../providers/device_provider.dart';
import '../../widgets/animated_toggle.dart';
import '../../widgets/glass_card.dart';
import 'widgets/color_picker_wheel.dart';
import 'widgets/camera_control_widget.dart';
import 'widgets/fan_control_widget.dart';
import 'widgets/speaker_control_widget.dart';
import 'widgets/activity_timeline.dart';
import 'widgets/schedule_picker.dart';

/// Deep-dive control screen for an individual smart device.
class DeviceDetailScreen extends StatelessWidget {
  final String deviceId;

  const DeviceDetailScreen({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceProvider>();
    final device = provider.getDeviceById(deviceId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (device == null) {
      return Scaffold(
        body: Center(
          child: Text('Device not found', style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + title
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        device.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    AnimatedToggle(
                      value: device.isActive,
                      activeColor: _accentColor(device.type),
                      onChanged: (_) => provider.toggleDevice(deviceId),
                    ),
                    const SizedBox(width: 8),
                    // Favorite button
                    GestureDetector(
                      onTap: () => provider.toggleFavorite(deviceId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: device.isFavorite
                              ? AppColors.accentAmber.withOpacity(0.15)
                              : isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurfaceVariant,
                        ),
                        child: Icon(
                          device.isFavorite
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 20,
                          color: device.isFavorite
                              ? AppColors.accentAmber
                              : isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Device hero card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  isActive: device.isActive,
                  activeGlowColor: _accentColor(device.type),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Large icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: device.isActive
                              ? _accentColor(device.type).withOpacity(0.15)
                              : isDark
                                  ? AppColors.darkSurfaceVariant
                                  : AppColors.lightSurfaceVariant,
                        ),
                        child: Icon(
                          device.icon,
                          size: 36,
                          color: device.isActive
                              ? _accentColor(device.type)
                              : isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        device.room,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: device.isActive
                              ? _accentColor(device.type)
                              : isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Type-specific controls
              if (device.isActive)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildDetailControls(context, device, provider),
                ),

              const SizedBox(height: 24),

              // Schedule Picker
              if (device.isActive)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SchedulePicker(),
                ),

              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'RECENT ACTIVITY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ActivityTimeline(
                      activities: provider.getDeviceActivities(deviceId),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailControls(
    BuildContext context,
    SmartDevice device,
    DeviceProvider provider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (device.type) {
      case DeviceType.light:
        final light = device as SmartLight;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brightness control
            Text(
              'Brightness',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.brightness_low, size: 20, color: AppColors.accentAmber),
                Expanded(
                  child: Slider(
                    value: light.brightness,
                    onChanged: (v) => provider.updateBrightness(deviceId, v),
                    activeColor: AppColors.accentAmber,
                  ),
                ),
                const Icon(Icons.brightness_high, size: 20, color: AppColors.accentAmber),
                const SizedBox(width: 8),
                Text(
                  '${(light.brightness * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentAmber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Color picker
            ColorPickerWheel(
              currentColor: light.color,
              onColorChanged: (c) => provider.updateLightColor(deviceId, c),
            ),
            const SizedBox(height: 28),

            // Color Presets
            Text(
              'Color Presets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _colorPreset(context, 'Warm', const Color(0xFFFFD700), provider, deviceId),
                  _colorPreset(context, 'Cool', const Color(0xFFE2E8F0), provider, deviceId),
                  _colorPreset(context, 'Relax', const Color(0xFFF43F5E), provider, deviceId),
                  _colorPreset(context, 'Focus', const Color(0xFF06B6D4), provider, deviceId),
                  _colorPreset(context, 'Movie', const Color(0xFF8B5CF6), provider, deviceId),
                ],
              ),
            ),
          ],
        );

      case DeviceType.ac:
        final ac = device as SmartAC;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Temperature
            Text(
              'Temperature',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _controlButton(
                    context,
                    Icons.remove,
                    () => provider.updateTemperature(deviceId, ac.temperature - 1),
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text(
                        '${ac.temperature}',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: AppColors.electricCyan,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.electricCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  _controlButton(
                    context,
                    Icons.add,
                    () => provider.updateTemperature(deviceId, ac.temperature + 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Mode selector
            Text(
              'Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ACMode.values.map((mode) {
                final isSelected = ac.mode == mode;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => provider.updateACMode(deviceId, mode),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: isSelected
                            ? AppColors.electricCyan.withOpacity(0.15)
                            : isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurfaceVariant,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.electricCyan.withOpacity(0.4)
                              : isDark
                                  ? AppColors.glassBorder
                                  : AppColors.glassBorderLight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _modeIcon(mode),
                            size: 22,
                            color: isSelected
                                ? AppColors.electricCyan
                                : isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            mode.name[0].toUpperCase() + mode.name.substring(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
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
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Quick Presets
            Text(
              'Quick Presets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _acPreset(context, 'Eco', 26, provider, deviceId),
                  _acPreset(context, 'Sleep', 24, provider, deviceId),
                  _acPreset(context, 'Turbo', 18, provider, deviceId),
                ],
              ),
            ),
          ],
        );

      case DeviceType.lock:
        final lock = device as SmartLock;
        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => provider.toggleLock(deviceId),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lock.isLocked
                        ? AppColors.accentGreen.withOpacity(0.12)
                        : AppColors.accentRose.withOpacity(0.12),
                    border: Border.all(
                      color: lock.isLocked
                          ? AppColors.accentGreen.withOpacity(0.4)
                          : AppColors.accentRose.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    lock.isLocked
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                    size: 48,
                    color: lock.isLocked
                        ? AppColors.accentGreen
                        : AppColors.accentRose,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lock.isLocked ? 'Locked' : 'Unlocked',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: lock.isLocked
                      ? AppColors.accentGreen
                      : AppColors.accentRose,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap to ${lock.isLocked ? "unlock" : "lock"}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );

      case DeviceType.tv:
        final tv = device as SmartTV;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volume',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.volume_mute, size: 20, color: AppColors.neonIndigo),
                Expanded(
                  child: Slider(
                    value: tv.volume,
                    onChanged: (v) => provider.updateVolume(deviceId, v),
                    activeColor: AppColors.neonIndigo,
                  ),
                ),
                const Icon(Icons.volume_up, size: 20, color: AppColors.neonIndigo),
                const SizedBox(width: 8),
                Text(
                  '${(tv.volume * 100).round()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.neonIndigo,
                  ),
                ),
              ],
            ),
          ],
        );

      case DeviceType.camera:
        final camera = device as SmartCamera;
        return CameraControlWidget(camera: camera, provider: provider);

      case DeviceType.fan:
        final fan = device as SmartFan;
        return FanControlWidget(fan: fan, provider: provider);

      case DeviceType.speaker:
        final speaker = device as SmartSpeaker;
        return SpeakerControlWidget(speaker: speaker, provider: provider);
    }
  }

  Widget _controlButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurfaceVariant,
          border: Border.all(
            color: isDark
                ? AppColors.glassBorder
                : AppColors.glassBorderLight,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.electricCyan,
          size: 22,
        ),
      ),
    );
  }

  IconData _modeIcon(ACMode mode) {
    switch (mode) {
      case ACMode.cool:
        return Icons.ac_unit_rounded;
      case ACMode.heat:
        return Icons.whatshot_rounded;
      case ACMode.fan:
        return Icons.air_rounded;
    }
  }

  Color _accentColor(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return AppColors.accentAmber;
      case DeviceType.ac:
        return AppColors.electricCyan;
      case DeviceType.lock:
        return AppColors.accentGreen;
      case DeviceType.tv:
        return AppColors.neonIndigo;
      case DeviceType.camera:
        return AppColors.accentRose;
      case DeviceType.fan:
        return AppColors.electricCyan;
      case DeviceType.speaker:
        return AppColors.neonIndigo;
    }
  }

  Widget _colorPreset(BuildContext context, String label, Color color, DeviceProvider provider, String deviceId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => provider.updateLightColor(deviceId, color),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _acPreset(BuildContext context, String label, int temp, DeviceProvider provider, String deviceId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => provider.updateTemperature(deviceId, temp),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.thermostat_rounded, size: 16, color: AppColors.electricCyan),
            const SizedBox(width: 6),
            Text(
              '$label ($temp°C)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

