import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/routine.dart';
import '../../providers/routine_provider.dart';
import '../../providers/scene_provider.dart';
import '../../widgets/glass_card.dart';

/// Screen for managing scheduled home automation routines.
class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final routines = routineProvider.routines;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Routines',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Schedule your smart home automations',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Add button
                  GestureDetector(
                    onTap: () =>
                        _showCreateRoutineSheet(context, routineProvider),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.electricCyan.withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Active routines summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGreen.withOpacity(0.12),
                      ),
                      child: const Icon(Icons.play_circle_rounded,
                          color: AppColors.accentGreen, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${routineProvider.activeCount} Active Routines',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${routines.length} total configured',
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Routines list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: routines.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(60),
                        child: Column(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 48,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No routines yet',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final routine = routines[index];
                        return _RoutineCard(
                          routine: routine,
                          onToggle: () =>
                              routineProvider.toggleRoutine(routine.id),
                          onDelete: () =>
                              routineProvider.removeRoutine(routine.id),
                        );
                      },
                      childCount: routines.length,
                    ),
                  ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showCreateRoutineSheet(
      BuildContext context, RoutineProvider routineProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sceneProvider = context.read<SceneProvider>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
    List<int> selectedDays = [1, 2, 3, 4, 5];
    String? selectedSceneId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                // Drag handle
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle_rounded,
                          color: AppColors.electricCyan),
                      const SizedBox(width: 10),
                      Text(
                        'Create Routine',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Name
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Routine name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.electricCyan, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Description
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          hintText: 'Description (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.electricCyan, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Time picker
                      GlassCard(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: ctx,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setSheetState(() => selectedTime = time);
                          }
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                color: AppColors.electricCyan, size: 22),
                            const SizedBox(width: 12),
                            const Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.electricCyan
                                    .withOpacity(0.12),
                              ),
                              child: Text(
                                selectedTime.format(ctx),
                                style: const TextStyle(
                                  color: AppColors.electricCyan,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Days selector
                      Text(
                        'REPEAT ON',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          final day = i + 1;
                          final isSelected = selectedDays.contains(day);
                          const labels = [
                            'M', 'T', 'W', 'T', 'F', 'S', 'S'
                          ];
                          return GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                if (isSelected) {
                                  selectedDays.remove(day);
                                } else {
                                  selectedDays.add(day);
                                  selectedDays.sort();
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.electricCyan
                                    : isDark
                                        ? AppColors.darkSurface
                                        : AppColors.lightSurfaceVariant,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.electricCyan
                                      : isDark
                                          ? AppColors.glassBorder
                                          : AppColors.glassBorderLight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors
                                                .lightTextSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Link to scene (optional)
                      Text(
                        'LINK TO SCENE (OPTIONAL)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...sceneProvider.scenes.map((scene) {
                        final isSelected =
                            selectedSceneId == scene.id;
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8),
                          child: GlassCard(
                            isActive: isSelected,
                            activeGlowColor:
                                scene.accentColors.first,
                            onTap: () {
                              setSheetState(() {
                                selectedSceneId = isSelected
                                    ? null
                                    : scene.id;
                              });
                            },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Icon(scene.icon,
                                    color: isSelected
                                        ? scene.accentColors.first
                                        : isDark
                                            ? AppColors
                                                .darkTextSecondary
                                            : AppColors
                                                .lightTextSecondary,
                                    size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  scene.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected)
                                  const Icon(
                                      Icons.check_circle_rounded,
                                      color:
                                          AppColors.electricCyan,
                                      size: 20),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Create button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: nameController.text.trim().isNotEmpty ||
                              descController.text.trim().isNotEmpty
                          ? () {
                              routineProvider.addRoutine(
                                Routine(
                                  id: 'routine_${DateTime.now().millisecondsSinceEpoch}',
                                  name: nameController.text.trim().isEmpty
                                      ? 'New Routine'
                                      : nameController.text.trim(),
                                  description:
                                      descController.text.trim(),
                                  time: selectedTime,
                                  days: selectedDays,
                                  sceneId: selectedSceneId,
                                ),
                              );
                              Navigator.pop(ctx);
                            }
                          : () {
                              routineProvider.addRoutine(
                                Routine(
                                  id: 'routine_${DateTime.now().millisecondsSinceEpoch}',
                                  name: 'New Routine',
                                  description: '',
                                  time: selectedTime,
                                  days: selectedDays,
                                  sceneId: selectedSceneId,
                                ),
                              );
                              Navigator.pop(ctx);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricCyan,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Create Routine',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _RoutineCard({
    required this.routine,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        isActive: routine.isEnabled,
        activeGlowColor: routine.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: routine.color.withOpacity(
                        routine.isEnabled ? 0.15 : 0.08),
                  ),
                  child: Icon(
                    routine.icon,
                    color: routine.isEnabled
                        ? routine.color
                        : isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: routine.isEnabled
                              ? null
                              : isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                        ),
                      ),
                      if (routine.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          routine.description,
                          style: TextStyle(
                            fontSize: 12,
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

                // Toggle
                Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    value: routine.isEnabled,
                    onChanged: (_) => onToggle(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Time & Days row
            Row(
              children: [
                // Time badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: routine.color.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14, color: routine.color),
                      const SizedBox(width: 4),
                      Text(
                        routine.timeString,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: routine.color,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Days badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isDark
                        ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                        : AppColors.lightSurfaceVariant,
                  ),
                  child: Text(
                    routine.daysSummary,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),

                const Spacer(),

                // Delete button
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.accentRose.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: AppColors.accentRose,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
