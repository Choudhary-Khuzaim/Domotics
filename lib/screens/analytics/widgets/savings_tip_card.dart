import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Dynamic eco-tip card with gradient accent and leaf icon.
class SavingsTipCard extends StatelessWidget {
  final String tip;
  final VoidCallback onNextTip;

  const SavingsTipCard({
    super.key,
    required this.tip,
    required this.onNextTip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentGreen.withOpacity(0.15),
            AppColors.electricCyan.withOpacity(0.08),
          ],
        ),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.accentGreen.withOpacity(0.15),
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: AppColors.accentGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Savings Tip',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onNextTip,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentGreen.withOpacity(0.12),
                        ),
                        child: const Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  tip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
