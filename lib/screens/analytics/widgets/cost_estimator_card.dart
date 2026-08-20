import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../app_theme.dart';
import '../../../../providers/energy_provider.dart';
import '../../../../providers/settings_provider.dart';

/// Card showing estimated energy bill cost ($), peak usage time, and budget progress.
class CostEstimatorCard extends StatelessWidget {
  const CostEstimatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = context.watch<SettingsProvider>();
    final energyProvider = context.watch<EnergyProvider>();
    final totalUsage = energyProvider.totalUsage;
    final totalCost = totalUsage * settings.energyRate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(
            color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentGreen.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.electric_bolt_rounded,
                    color: AppColors.accentGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Electricity Bill',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 15,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Based on current rate (${settings.currency} ${settings.energyRate.toStringAsFixed(1)} / kWh)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${settings.currency} ${totalCost.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 14),

            // Monthly Energy Budget Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Energy Budget Goal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const Text(
                  '232 / 300 kWh',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.electricCyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: 0.77,
              padding: EdgeInsets.zero,
              barRadius: const Radius.circular(6),
              linearGradient: AppColors.primaryGradient,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
            ),
            const SizedBox(height: 16),

            // Peak Usage Tip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.accentAmber.withOpacity(0.12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.access_time_filled_rounded,
                    size: 16,
                    color: AppColors.accentAmber,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Peak Usage Hours: 7:00 PM – 9:00 PM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentAmber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
