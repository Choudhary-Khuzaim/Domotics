import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Animated radar/pulse effect for BLE scanning visualization.
class RadarAnimation extends StatefulWidget {
  final bool isScanning;
  final int discoveredCount;

  const RadarAnimation({
    super.key,
    required this.isScanning,
    this.discoveredCount = 0,
  });

  @override
  State<RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _sweepController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.isScanning) {
      _pulseController.repeat();
      _sweepController.repeat();
    }
  }

  @override
  void didUpdateWidget(RadarAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _pulseController.repeat();
      _sweepController.repeat();
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _pulseController.stop();
      _sweepController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _sweepController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _RadarPainter(
              pulseProgress: _pulseController.value,
              sweepAngle: _sweepController.value * 2 * pi,
              isScanning: widget.isScanning,
              discoveredCount: widget.discoveredCount,
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double pulseProgress;
  final double sweepAngle;
  final bool isScanning;
  final int discoveredCount;

  _RadarPainter({
    required this.pulseProgress,
    required this.sweepAngle,
    required this.isScanning,
    required this.discoveredCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw concentric rings
    for (int i = 1; i <= 3; i++) {
      final ringRadius = maxRadius * (i / 3);
      final ringPaint = Paint()
        ..color = AppColors.electricCyan.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // Center dot
    final centerDotPaint = Paint()
      ..color = AppColors.electricCyan
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, centerDotPaint);

    if (!isScanning) return;

    // Pulsing ring
    final pulseRadius = maxRadius * pulseProgress;
    final pulsePaint = Paint()
      ..color = AppColors.electricCyan.withOpacity(0.25 * (1 - pulseProgress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, pulseRadius, pulsePaint);

    // Sweep line
    final sweepEnd = Offset(
      center.dx + maxRadius * cos(sweepAngle),
      center.dy + maxRadius * sin(sweepAngle),
    );
    final sweepPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.electricCyan.withOpacity(0.6),
          AppColors.electricCyan.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..strokeWidth = 2;
    canvas.drawLine(center, sweepEnd, sweepPaint);

    // Sweep arc glow
    final sweepArcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: sweepAngle - 0.5,
        endAngle: sweepAngle,
        colors: [
          AppColors.electricCyan.withOpacity(0.0),
          AppColors.electricCyan.withOpacity(0.15),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius * 0.85, sweepArcPaint);

    // Draw discovered device dots at fixed positions around the radar
    final random = Random(42); // Fixed seed for consistent positions
    for (int i = 0; i < discoveredCount && i < 8; i++) {
      final angle = (2 * pi / 8) * i + 0.3;
      final dist = 0.3 + random.nextDouble() * 0.5;
      final dotCenter = Offset(
        center.dx + maxRadius * dist * cos(angle),
        center.dy + maxRadius * dist * sin(angle),
      );
      final dotPaint = Paint()
        ..color = AppColors.electricCyan
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, 4, dotPaint);

      // Glow around dot
      final glowPaint = Paint()
        ..color = AppColors.electricCyan.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, 8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}
