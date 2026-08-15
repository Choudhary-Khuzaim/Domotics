import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../providers/device_provider.dart';
import '../../../providers/notification_provider.dart';

/// Quick Master Action Controls for home-wide management.
class MasterControlsCard extends StatelessWidget {
  const MasterControlsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.read<DeviceProvider>();
    final notificationProvider = context.read<NotificationProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildActionCard(
            context: context,
            isDark: isDark,
            title: 'Lights Off',
            icon: Icons.lightbulb_outline_rounded,
            color: AppColors.accentAmber,
            onTap: () {
              deviceProvider.turnOffAllLights();
              _showFeedback(context, notificationProvider, 'All lights turned off', Icons.lightbulb_outline);
            },
          ),
          const SizedBox(width: 12),
          _buildActionCard(
            context: context,
            isDark: isDark,
            title: 'Lock Doors',
            icon: Icons.lock_outline_rounded,
            color: AppColors.accentGreen,
            onTap: () {
              deviceProvider.lockAllDoors();
              _showFeedback(context, notificationProvider, 'All doors locked', Icons.lock_outline);
            },
          ),
          const SizedBox(width: 12),
          _buildActionCard(
            context: context,
            isDark: isDark,
            title: 'Away Mode',
            icon: Icons.flight_takeoff_rounded,
            color: AppColors.electricCyan,
            onTap: () {
              deviceProvider.activateAwayMode();
              _showFeedback(context, notificationProvider, 'Away mode activated', Icons.flight_takeoff);
            },
          ),
          const SizedBox(width: 12),
          _buildActionCard(
            context: context,
            isDark: isDark,
            title: 'Night Mode',
            icon: Icons.nights_stay_rounded,
            color: AppColors.neonIndigo,
            onTap: () {
              deviceProvider.activateNightMode();
              _showFeedback(context, notificationProvider, 'Night mode activated', Icons.nights_stay);
            },
          ),
          const SizedBox(width: 12),
          _buildActionCard(
            context: context,
            isDark: isDark,
            title: 'Party Mode',
            icon: Icons.celebration_rounded,
            color: AppColors.accentRose,
            onTap: () {
              deviceProvider.activatePartyMode();
              _showFeedback(context, notificationProvider, 'Party mode activated!', Icons.celebration);
            },
          ),
        ],
      ),
    );
  }

  void _showFeedback(BuildContext context, NotificationProvider provider, String message, IconData icon) {
    provider.addNotification(
      title: 'Master Action',
      message: message,
      icon: icon,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
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
