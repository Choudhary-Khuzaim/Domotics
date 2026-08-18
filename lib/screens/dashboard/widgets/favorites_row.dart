import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/device_provider.dart';
import '../../../widgets/page_transitions.dart';
import '../../device_detail/device_detail_screen.dart';

/// Horizontal scrollable row of favorite devices for quick access.
class FavoritesRow extends StatelessWidget {
  const FavoritesRow({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final favorites = deviceProvider.favorites;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (favorites.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 16,
                color: AppColors.accentAmber,
              ),
              const SizedBox(width: 6),
              Text(
                'FAVORITES',
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
        ),
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final device = favorites[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      SlideUpRoute(
                        page: DeviceDetailScreen(deviceId: device.id),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      border: Border.all(
                        color: device.isActive
                            ? AppColors.electricCyan.withOpacity(0.4)
                            : isDark
                                ? AppColors.glassBorder
                                : AppColors.glassBorderLight,
                        width: device.isActive ? 1.5 : 1,
                      ),
                      boxShadow: device.isActive
                          ? [
                              BoxShadow(
                                color:
                                    AppColors.electricCyan.withOpacity(0.08),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Status dot
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: device.isActive
                                ? AppColors.accentGreen
                                : isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                            boxShadow: device.isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.accentGreen
                                          .withOpacity(0.5),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          device.icon,
                          size: 16,
                          color: device.isActive
                              ? AppColors.electricCyan
                              : isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          device.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: device.isActive
                                ? null
                                : isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
