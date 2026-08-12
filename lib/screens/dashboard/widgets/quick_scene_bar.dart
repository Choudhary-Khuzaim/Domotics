import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/device_provider.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/scene_provider.dart';

/// Quick horizontal scene selector pills for the Dashboard.
class QuickSceneBar extends StatelessWidget {
  const QuickSceneBar({super.key});

  @override
  Widget build(BuildContext context) {
    final sceneProvider = context.watch<SceneProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final scenes = sceneProvider.scenes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Quick Scenes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: scenes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final scene = scenes[index];
              return GestureDetector(
                onTap: () {
                  sceneProvider.executeScene(
                    sceneId: scene.id,
                    deviceProvider: deviceProvider,
                    notificationProvider: notificationProvider,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: scene.gradient,
                    boxShadow: [
                      BoxShadow(
                        color: scene.accentColors.first.withOpacity(0.25),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (scene.isExecuting)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        Icon(scene.icon, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        scene.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
