import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/smart_device.dart';
import '../../../providers/device_provider.dart';

/// Control widget for Smart Security Cameras.
class CameraControlWidget extends StatelessWidget {
  final SmartCamera camera;
  final DeviceProvider provider;

  const CameraControlWidget({
    super.key,
    required this.camera,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Camera Viewfinder Simulation
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: camera.isNightVision
                  ? const LinearGradient(
                      colors: [Color(0xFF042F2C), Color(0xFF0D5C54)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: Border.all(
                color: camera.isNightVision
                    ? AppColors.accentGreen.withOpacity(0.5)
                    : AppColors.electricCyan.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Background grid pattern simulation
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        camera.isNightVision
                            ? Icons.remove_red_eye_outlined
                            : Icons.videocam_rounded,
                        size: 56,
                        color: (camera.isNightVision
                                ? AppColors.accentGreen
                                : AppColors.electricCyan)
                            .withOpacity(0.35),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PAN ANGLE: ${camera.panAngle}°',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                          color: (camera.isNightVision
                                  ? AppColors.accentGreen
                                  : AppColors.electricCyan)
                              .withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Live status tag
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentRose,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'LIVE • 1080p',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Motion alert overlay tag if motion detected
                if (camera.isMotionDetected)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accentRose.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'MOTION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Pan/Tilt D-Pad & Controls
        Row(
          children: [
            // Pan Controls D-Pad
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurfaceVariant,
                  border: Border.all(
                    color: isDark
                        ? AppColors.glassBorder
                        : AppColors.glassBorderLight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppColors.electricCyan,
                      onPressed: () => provider.adjustCameraPan(camera.id, -15),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pan_tool_rounded,
                            size: 18, color: AppColors.darkTextMuted),
                        SizedBox(height: 2),
                        Text(
                          'PAN',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      color: AppColors.electricCyan,
                      onPressed: () => provider.adjustCameraPan(camera.id, 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Night Vision Toggle Switch
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurfaceVariant,
            border: Border.all(
              color:
                  isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.nightlight_round,
                  color: AppColors.accentGreen, size: 22),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Night Vision Mode',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Switch(
                value: camera.isNightVision,
                activeColor: AppColors.accentGreen,
                onChanged: (_) =>
                    provider.toggleCameraNightVision(camera.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
