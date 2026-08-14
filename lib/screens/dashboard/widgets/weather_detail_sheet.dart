import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widgets/glass_card.dart';

/// Expanded weather detail bottom sheet with forecast and conditions.
class WeatherDetailSheet extends StatelessWidget {
  const WeatherDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.wb_sunny_rounded,
                    color: AppColors.accentAmber, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Weather',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 20),
                ),
                const Spacer(),
                Text(
                  'Islamabad',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Current temp & condition
                GlassCard(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.primaryGradient
                                    .createShader(bounds),
                            child: const Text(
                              '24°C',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Partly Cloudy',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 15),
                          ),
                          Text(
                            'Feels like 26°C',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.wb_cloudy_rounded,
                        size: 64,
                        color: AppColors.accentAmber.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Conditions grid
                Row(
                  children: [
                    Expanded(
                      child: _ConditionCard(
                        icon: Icons.water_drop_rounded,
                        label: 'Humidity',
                        value: '65%',
                        color: AppColors.electricCyan,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ConditionCard(
                        icon: Icons.air_rounded,
                        label: 'Wind',
                        value: '12 km/h',
                        color: AppColors.neonIndigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ConditionCard(
                        icon: Icons.wb_sunny_rounded,
                        label: 'UV Index',
                        value: '6 High',
                        color: AppColors.accentAmber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ConditionCard(
                        icon: Icons.visibility_rounded,
                        label: 'Visibility',
                        value: '10 km',
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 3-day forecast
                Text(
                  '3-DAY FORECAST',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 10),

                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _ForecastRow(
                        day: 'Tomorrow',
                        icon: Icons.wb_sunny_rounded,
                        iconColor: AppColors.accentAmber,
                        high: '26°',
                        low: '18°',
                        condition: 'Sunny',
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 16,
                        endIndent: 16,
                        color: isDark
                            ? AppColors.glassBorder
                            : AppColors.glassBorderLight,
                      ),
                      _ForecastRow(
                        day: 'Saturday',
                        icon: Icons.wb_cloudy_rounded,
                        iconColor: AppColors.darkTextMuted,
                        high: '23°',
                        low: '16°',
                        condition: 'Cloudy',
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 16,
                        endIndent: 16,
                        color: isDark
                            ? AppColors.glassBorder
                            : AppColors.glassBorderLight,
                      ),
                      _ForecastRow(
                        day: 'Sunday',
                        icon: Icons.thunderstorm_rounded,
                        iconColor: AppColors.neonIndigo,
                        high: '21°',
                        low: '15°',
                        condition: 'Rain',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Smart home tip
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentGreen.withOpacity(0.12),
                        ),
                        child: const Icon(Icons.tips_and_updates_rounded,
                            color: AppColors.accentGreen, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Smart Tip',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accentGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'UV is high today — close smart blinds between 12-4 PM to reduce AC load.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConditionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ConditionCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final String day;
  final IconData icon;
  final Color iconColor;
  final String high;
  final String low;
  final String condition;

  const _ForecastRow({
    required this.day,
    required this.icon,
    required this.iconColor,
    required this.high,
    required this.low,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            condition,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const Spacer(),
          Text(
            high,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            low,
            style: TextStyle(
              fontSize: 14,
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
