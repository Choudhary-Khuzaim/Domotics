import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/smart_device.dart';
import '../../../providers/device_provider.dart';

/// Control widget for Smart Fans.
class FanControlWidget extends StatelessWidget {
  final SmartFan fan;
  final DeviceProvider provider;

  const FanControlWidget({
    super.key,
    required this.fan,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Speed Level Label
        Text(
          'Fan Speed (Level ${fan.speed})',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 14),

        // Speed 1 - 5 selector buttons
        Row(
          children: List.generate(5, (index) {
            final level = index + 1;
            final isSelected = fan.speed == level;

            return Expanded(
              child: GestureDetector(
                onTap: () => provider.updateFanSpeed(fan.id, level),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isSelected
                        ? AppColors.electricCyan
                        : isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurfaceVariant,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.electricCyan.withOpacity(0.35),
                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        // Oscillation Mode Container
        GestureDetector(
          onTap: () => provider.toggleFanOscillation(fan.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightSurfaceVariant,
              border: Border.all(
                color: fan.isOscillating
                    ? AppColors.electricCyan.withOpacity(0.4)
                    : isDark
                        ? AppColors.glassBorder
                        : AppColors.glassBorderLight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sync_rounded,
                  color: fan.isOscillating
                      ? AppColors.electricCyan
                      : AppColors.darkTextMuted,
                  size: 24,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Oscillation Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        fan.isOscillating ? 'Sweeping air left to right' : 'Fixed airflow position',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: fan.isOscillating,
                  activeColor: AppColors.electricCyan,
                  onChanged: (_) => provider.toggleFanOscillation(fan.id),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
