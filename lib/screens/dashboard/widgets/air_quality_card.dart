import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Indoor Air Quality & Environmental Stat Card for Dashboard.
class AirQualityCard extends StatelessWidget {
  const AirQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF0F2027),
                    const Color(0xFF203A43),
                  ]
                : [
                    const Color(0xFFE0F2FE),
                    const Color(0xFFBAE6FD),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDark
                ? AppColors.electricCyan.withOpacity(0.3)
                : AppColors.electricCyan.withOpacity(0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // AQI Index
            _buildMetricItem(
              context: context,
              icon: Icons.air_rounded,
              iconColor: AppColors.accentGreen,
              title: 'Indoor AQI',
              value: '98 (Good)',
              isDark: isDark,
            ),
            Container(
              height: 36,
              width: 1,
              color: isDark
                  ? AppColors.glassBorder
                  : Colors.black.withOpacity(0.1),
            ),

            // Humidity
            _buildMetricItem(
              context: context,
              icon: Icons.water_drop_rounded,
              iconColor: AppColors.electricCyan,
              title: 'Humidity',
              value: '48%',
              isDark: isDark,
            ),
            Container(
              height: 36,
              width: 1,
              color: isDark
                  ? AppColors.glassBorder
                  : Colors.black.withOpacity(0.1),
            ),

            // PM2.5
            _buildMetricItem(
              context: context,
              icon: Icons.filter_vintage_rounded,
              iconColor: AppColors.accentAmber,
              title: 'PM2.5 Level',
              value: '12 µg/m³',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
