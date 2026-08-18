import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_theme.dart';
import '../../../models/smart_device.dart';
import '../../../providers/device_provider.dart';

/// Real-time security status card showing locks, cameras and motion alerts.
class SecurityStatusCard extends StatelessWidget {
  const SecurityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();

    final locks = deviceProvider.devices.whereType<SmartLock>().toList();
    final cameras = deviceProvider.devices.whereType<SmartCamera>().toList();
    final lockedCount = locks.where((l) => l.isLocked).length;
    final activeCams = cameras.where((c) => c.isActive).length;
    final motionDetected = cameras.any((c) => c.isMotionDetected);

    final allSecure = lockedCount == locks.length && activeCams == cameras.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: allSecure
                ? [const Color(0xFF0D3B2E), const Color(0xFF1A4A3A)]
                : [const Color(0xFF3B1A1A), const Color(0xFF4A2020)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: allSecure
                ? AppColors.accentGreen.withOpacity(0.25)
                : AppColors.accentRose.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: (allSecure ? AppColors.accentGreen : AppColors.accentRose)
                  .withOpacity(0.1),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (allSecure
                              ? AppColors.accentGreen
                              : AppColors.accentRose)
                          .withOpacity(0.2),
                    ),
                    child: Icon(
                      allSecure
                          ? Icons.shield_rounded
                          : Icons.shield_outlined,
                      color: allSecure
                          ? AppColors.accentGreen
                          : AppColors.accentRose,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allSecure ? 'Home Secure' : 'Attention Needed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        allSecure
                            ? 'All systems armed & operational'
                            : 'Some security systems need attention',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Animated status dot
                  _PulsingDot(
                    color: allSecure
                        ? AppColors.accentGreen
                        : AppColors.accentRose,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Status row
              Row(
                children: [
                  _SecurityStat(
                    icon: Icons.lock_rounded,
                    label: 'Doors',
                    value: '$lockedCount/${locks.length}',
                    sublabel: 'Locked',
                    color: lockedCount == locks.length
                        ? AppColors.accentGreen
                        : AppColors.accentAmber,
                  ),
                  const SizedBox(width: 12),
                  _SecurityStat(
                    icon: Icons.videocam_rounded,
                    label: 'Cameras',
                    value: '$activeCams/${cameras.length}',
                    sublabel: 'Active',
                    color: activeCams == cameras.length
                        ? AppColors.accentGreen
                        : AppColors.accentAmber,
                  ),
                  const SizedBox(width: 12),
                  _SecurityStat(
                    icon: Icons.motion_photos_on_rounded,
                    label: 'Motion',
                    value: motionDetected ? 'Yes' : 'No',
                    sublabel: 'Detected',
                    color: motionDetected
                        ? AppColors.accentAmber
                        : AppColors.accentGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sublabel;
  final Color color;

  const _SecurityStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.06),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A pulsing dot to indicate live status.
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5 * _animation.value),
                blurRadius: 8 * _animation.value,
                spreadRadius: 2 * _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
