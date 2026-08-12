import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app_theme.dart';
import '../../../models/energy_data.dart';

/// Line chart showing energy usage (kWh) over the selected time period.
class UsageChart extends StatelessWidget {
  final List<EnergyDataPoint> data;

  const UsageChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxY = data.map((d) => d.kWh).reduce((a, b) => a > b ? a : b);
    final ceiledMax = (maxY * 1.2).ceilToDouble();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(8, 24, 20, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? AppColors.darkSurface.withOpacity(0.6)
            : AppColors.lightSurface,
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 18,
                  color: AppColors.electricCyan,
                ),
                const SizedBox(width: 6),
                Text(
                  'Energy Usage',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Text(
                  '${data.fold<double>(0, (s, d) => s + d.kWh).toStringAsFixed(1)} kWh',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.electricCyan,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: ceiledMax / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                        : AppColors.lightSurfaceVariant,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            data[idx].label,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 0,
                maxY: ceiledMax,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) =>
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)} kWh',
                          const TextStyle(
                            color: AppColors.electricCyan,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (i) => FlSpot(i.toDouble(), data[i].kWh),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.electricCyan,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.electricCyan,
                        strokeWidth: 2,
                        strokeColor: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.electricCyan.withOpacity(0.25),
                          AppColors.electricCyan.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
