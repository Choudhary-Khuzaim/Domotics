import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/energy_data.dart';

/// Segmented time filter control: Day / Week / Month / Year.
class TimeFilterWidget extends StatelessWidget {
  final TimeFilter selectedFilter;
  final ValueChanged<TimeFilter> onFilterChanged;

  const TimeFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurfaceVariant.withOpacity(0.6),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
        ),
      ),
      child: Row(
        children: TimeFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected
                      ? AppColors.electricCyan.withOpacity(0.15)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: AppColors.electricCyan.withOpacity(0.3),
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    filter.name[0].toUpperCase() + filter.name.substring(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.electricCyan
                          : isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
