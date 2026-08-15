import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../app_theme.dart';

/// Color picker wheel for controlling Smart RGB Light color.
class ColorPickerWheel extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWheel({
    super.key,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Light Color',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
                border: Border.all(
                  color: isDark
                      ? AppColors.glassBorder
                      : AppColors.glassBorderLight,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentColor.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 280,
            child: HueRingPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              enableAlpha: false,
              displayThumbColor: true,
              colorPickerHeight: 220,
              hueRingStrokeWidth: 20,
            ),
          ),
        ),
      ],
    );
  }
}
