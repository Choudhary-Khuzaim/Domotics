import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/scene.dart';
import '../../providers/device_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/scene_provider.dart';

/// Full screen dedicated to Smart Scenes and Home Automations.
class ScenesScreen extends StatelessWidget {
  const ScenesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sceneProvider = context.watch<SceneProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final scenes = sceneProvider.scenes;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
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
                          'Smart Scenes',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 24,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Execute multi-device presets with 1-tap automations',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  // Create scene button
                  GestureDetector(
                    onTap: () => _showCreateSceneSheet(context, sceneProvider),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricCyan.withOpacity(0.3),
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

          // Scene Cards List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final scene = scenes[index];
                  return _SceneCard(
                    scene: scene,
                    onTap: () {
                      sceneProvider.executeScene(
                        sceneId: scene.id,
                        deviceProvider: deviceProvider,
                        notificationProvider: notificationProvider,
                      );
                    },
                    onLongPress: () => _showDeleteSceneDialog(
                      context, sceneProvider, scene),
                  );
                },
                childCount: scenes.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showCreateSceneSheet(BuildContext context, SceneProvider sceneProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController();
    final descController = TextEditingController();
    int selectedIconIndex = 0;
    int selectedGradientIndex = 0;

    final availableIcons = [
      Icons.spa_rounded,
      Icons.coffee_rounded,
      Icons.celebration_rounded,
      Icons.fitness_center_rounded,
      Icons.music_note_rounded,
      Icons.restaurant_rounded,
      Icons.bedtime_rounded,
      Icons.work_rounded,
      Icons.child_care_rounded,
      Icons.pets_rounded,
      Icons.book_rounded,
      Icons.videogame_asset_rounded,
    ];

    final gradientPresets = [
      {
        'name': 'Ocean',
        'gradient': const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF00695C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'accents': const [Color(0xFF1565C0), Color(0xFF00897B)],
      },
      {
        'name': 'Sunset',
        'gradient': const LinearGradient(
          colors: [Color(0xFFBF360C), Color(0xFFF57F17)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'accents': const [Color(0xFFE64A19), Color(0xFFFFA000)],
      },
      {
        'name': 'Aurora',
        'gradient': const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'accents': const [Color(0xFF283593), Color(0xFF6A1B9A)],
      },
      {
        'name': 'Forest',
        'gradient': const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF33691E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'accents': const [Color(0xFF2E7D32), Color(0xFF558B2F)],
      },
      {
        'name': 'Rose',
        'gradient': const LinearGradient(
          colors: [Color(0xFF880E4F), Color(0xFFAD1457)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'accents': const [Color(0xFFC2185B), Color(0xFFD81B60)],
      },
      {
        'name': 'Midnight',
        'gradient': const LinearGradient(
          colors: [Color(0xFF0D1117), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'accents': const [Color(0xFF16213E), Color(0xFF0F3460)],
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.78,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle_rounded,
                          color: AppColors.electricCyan),
                      const SizedBox(width: 10),
                      Text(
                        'Create Scene',
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
                          hintText: 'Scene name',
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

                      // Icon picker
                      Text(
                        'CHOOSE ICON',
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: availableIcons.length,
                        itemBuilder: (_, i) {
                          final isSelected = i == selectedIconIndex;
                          return GestureDetector(
                            onTap: () {
                              setSheetState(() => selectedIconIndex = i);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? AppColors.electricCyan.withOpacity(0.15)
                                    : isDark
                                        ? AppColors.darkSurface
                                        : AppColors.lightSurfaceVariant,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.electricCyan
                                      : isDark
                                          ? AppColors.glassBorder
                                          : AppColors.glassBorderLight,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                availableIcons[i],
                                size: 22,
                                color: isSelected
                                    ? AppColors.electricCyan
                                    : isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Gradient picker
                      Text(
                        'CHOOSE STYLE',
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.2,
                        ),
                        itemCount: gradientPresets.length,
                        itemBuilder: (_, i) {
                          final preset = gradientPresets[i];
                          final isSelected = i == selectedGradientIndex;
                          return GestureDetector(
                            onTap: () {
                              setSheetState(() => selectedGradientIndex = i);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: preset['gradient'] as LinearGradient,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  preset['name'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                      onPressed: () {
                        final name = nameController.text.trim().isEmpty
                            ? 'Custom Scene'
                            : nameController.text.trim();
                        final selectedPreset = gradientPresets[selectedGradientIndex];
                        sceneProvider.addScene(
                          SmartScene(
                            id: 'scene_${DateTime.now().millisecondsSinceEpoch}',
                            name: name,
                            description: descController.text.trim(),
                            icon: availableIcons[selectedIconIndex],
                            gradient: selectedPreset['gradient'] as LinearGradient,
                            accentColors: selectedPreset['accents'] as List<Color>,
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
                        'Create Scene',
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

  void _showDeleteSceneDialog(
      BuildContext context, SceneProvider sceneProvider, SmartScene scene) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Scene'),
        content: Text('Are you sure you want to delete "${scene.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              sceneProvider.removeScene(scene.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRose,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  final SmartScene scene;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SceneCard({
    required this.scene,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: scene.gradient,
        boxShadow: [
          BoxShadow(
            color: scene.accentColors.first.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: scene.isExecuting ? null : onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.18),
                  ),
                  child: Icon(
                    scene.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Scene Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scene.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scene.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Activate Button / Spinner
                if (scene.isExecuting)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.22),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'Run',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
