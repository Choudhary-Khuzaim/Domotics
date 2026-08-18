import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/device_activity.dart';

/// Beautiful vertical timeline widget showing recent device activities.
class ActivityTimeline extends StatelessWidget {
  final List<DeviceActivity> activities;

  const ActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.history_rounded,
                size: 36,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
              const SizedBox(height: 8),
              Text(
                'No activity yet',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show at most 10 recent activities
    final displayActivities = activities.take(10).toList();

    return Column(
      children: List.generate(displayActivities.length, (index) {
        final activity = displayActivities[index];
        final isLast = index == displayActivities.length - 1;

        return _TimelineEntry(
          activity: activity,
          isLast: isLast,
          isDark: isDark,
        );
      }),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final DeviceActivity activity;
  final bool isLast;
  final bool isDark;

  const _TimelineEntry({
    required this.activity,
    required this.isLast,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 36,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activity.color.withOpacity(0.2),
                    border: Border.all(
                      color: activity.color,
                      width: 2,
                    ),
                  ),
                ),
                // Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: isDark
                          ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                          : AppColors.lightSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                border: Border.all(
                  color: isDark
                      ? AppColors.glassBorder
                      : AppColors.glassBorderLight,
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: activity.color.withOpacity(0.12),
                    ),
                    child: Icon(
                      activity.icon,
                      size: 16,
                      color: activity.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.action,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (activity.details.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            activity.details,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Timestamp
                  Text(
                    activity.relativeTime,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
