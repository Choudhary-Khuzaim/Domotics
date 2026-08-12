import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/smart_device.dart';
import '../../../providers/device_provider.dart';

/// Control widget for Smart Speakers and Audio Systems.
class SpeakerControlWidget extends StatelessWidget {
  final SmartSpeaker speaker;
  final DeviceProvider provider;

  const SpeakerControlWidget({
    super.key,
    required this.speaker,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Music Album Art & Controls Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonIndigo.withOpacity(0.3),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Album Art Placeholder
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Track Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          speaker.currentTrack,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          speaker.artist,
                          style: const TextStyle(
                            color: AppColors.darkTextSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Player Controls (Prev, Play/Pause, Next)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 28,
                    icon: const Icon(Icons.skip_previous_rounded),
                    color: Colors.white.withOpacity(0.8),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),

                  // Play/Pause Big Circle Button
                  GestureDetector(
                    onTap: () => provider.toggleSpeakerPlay(speaker.id),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricCyan,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(
                        speaker.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  IconButton(
                    iconSize: 28,
                    icon: const Icon(Icons.skip_next_rounded),
                    color: Colors.white.withOpacity(0.8),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Speaker Volume Control Slider
        Text(
          'Speaker Volume',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.volume_down_rounded,
                size: 20, color: AppColors.neonIndigo),
            Expanded(
              child: Slider(
                value: speaker.volume,
                onChanged: (v) => provider.updateVolume(speaker.id, v),
                activeColor: AppColors.neonIndigo,
              ),
            ),
            const Icon(Icons.volume_up_rounded,
                size: 20, color: AppColors.neonIndigo),
            const SizedBox(width: 8),
            Text(
              '${(speaker.volume * 100).round()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.neonIndigo,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
