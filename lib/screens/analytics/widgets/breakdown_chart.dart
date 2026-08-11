import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app_theme.dart';
import '../../../models/energy_data.dart';

/// Donut chart showing energy consumption breakdown by device category.
class BreakdownChart extends StatefulWidget {
  final List<DeviceConsumption> data;

  const BreakdownChart({super.key, required this.data});

  @override
  State<BreakdownChart> createState() => _BreakdownChartState();
}

class _BreakdownChartState extends State<BreakdownChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(Icons.pie_chart_rounded, size: 18, color: AppColors.neonIndigo),
              const SizedBox(width: 6),
              Text(
                'Consumption Breakdown',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Donut chart
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 45,
                sections: List.generate(widget.data.length, (index) {
                  final item = widget.data[index];
                  final isTouched = index == _touchedIndex;

                  return PieChartSectionData(
                    color: item.color,
                    value: item.percentage,
                    title: isTouched ? '${item.percentage.round()}%' : '',
                    radius: isTouched ? 42 : 34,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    titlePositionPercentageOffset: 0.55,
                  );
                }),
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: 20),

          // Legend
          ...widget.data.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    item.icon,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    '${item.percentage.round()}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: item.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
