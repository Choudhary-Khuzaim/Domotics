import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Schedule picker for setting ON/OFF times with day-of-week selection.
class SchedulePicker extends StatefulWidget {
  const SchedulePicker({super.key});

  @override
  State<SchedulePicker> createState() => _SchedulePickerState();
}

class _SchedulePickerState extends State<SchedulePicker> {
  TimeOfDay _onTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _offTime = const TimeOfDay(hour: 23, minute: 0);
  final Set<int> _selectedDays = {1, 2, 3, 4, 5}; // Mon-Fri by default
  final List<_Schedule> _savedSchedules = [];

  static const List<String> _dayLabels = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),

        // ON/OFF time pickers
        Row(
          children: [
            Expanded(
              child: _timeTile(
                context,
                'ON Time',
                _onTime,
                Icons.play_circle_outline,
                AppColors.accentGreen,
                () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _onTime,
                  );
                  if (picked != null) {
                    setState(() => _onTime = picked);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _timeTile(
                context,
                'OFF Time',
                _offTime,
                Icons.stop_circle_outlined,
                AppColors.accentRose,
                () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _offTime,
                  );
                  if (picked != null) {
                    setState(() => _offTime = picked);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Day-of-week chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = _selectedDays.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedDays.remove(index);
                  } else {
                    _selectedDays.add(index);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.electricCyan.withOpacity(0.15)
                      : isDark
                          ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                          : AppColors.lightSurfaceVariant,
                  border: isSelected
                      ? Border.all(
                          color: AppColors.electricCyan.withOpacity(0.4),
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    _dayLabels[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.electricCyan
                          : isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Save button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _savedSchedules.add(_Schedule(
                  onTime: _onTime,
                  offTime: _offTime,
                  days: Set.from(_selectedDays),
                ));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Schedule saved!'),
                  backgroundColor: AppColors.accentGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricCyan,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save Schedule',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),

        // Saved schedules
        if (_savedSchedules.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            'Saved Schedules',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(_savedSchedules.length, (index) {
            final schedule = _savedSchedules[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? AppColors.darkSurfaceVariant.withOpacity(0.3)
                    : AppColors.lightSurfaceVariant.withOpacity(0.5),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppColors.electricCyan,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${schedule.onTime.format(context)} → ${schedule.offTime.format(context)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() => _savedSchedules.removeAt(index));
                    },
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: AppColors.accentRose,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _timeTile(
    BuildContext context,
    String label,
    TimeOfDay time,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              time.format(context),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Schedule {
  final TimeOfDay onTime;
  final TimeOfDay offTime;
  final Set<int> days;

  _Schedule({
    required this.onTime,
    required this.offTime,
    required this.days,
  });
}
