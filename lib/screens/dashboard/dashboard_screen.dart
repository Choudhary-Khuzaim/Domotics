import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/device_provider.dart';
import '../../screens/device_detail/device_detail_screen.dart';
import '../../screens/add_device/add_device_screen.dart';
import 'widgets/greeting_header.dart';
import 'widgets/room_tabs.dart';
import 'widgets/device_card.dart';
import 'widgets/quick_scene_bar.dart';
import 'widgets/master_controls_card.dart';
import 'widgets/air_quality_card.dart';

/// Main dashboard / home screen displaying device cards by room.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedRoom = 'All Rooms';

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    final devices = deviceProvider.getDevicesByRoom(_selectedRoom);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        SafeArea(
      child: CustomScrollView(
        slivers: [
          // Greeting Header
          const SliverToBoxAdapter(
            child: GreetingHeader(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Indoor Air Quality Banner
          const SliverToBoxAdapter(
            child: AirQualityCard(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Quick Scene Bar
          const SliverToBoxAdapter(
            child: QuickSceneBar(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Master Action Quick Controls
          const SliverToBoxAdapter(
            child: MasterControlsCard(),
          ),

          // Active devices count & My Home section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.electricCyan.withOpacity(0.12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentGreen,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGreen.withOpacity(0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${deviceProvider.activeDeviceCount} Devices Active',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.electricCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'My Home',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Room tabs
          SliverToBoxAdapter(
            child: RoomTabs(
              selectedRoom: _selectedRoom,
              onRoomSelected: (room) {
                setState(() => _selectedRoom = room);
              },
            ),
          ),


          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Device grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: devices.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.devices_other_rounded,
                              size: 48,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No devices in this room',
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
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final device = devices[index];
                        return DeviceCard(
                          device: device,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DeviceDetailScreen(
                                  deviceId: device.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: devices.length,
                    ),
                  ),
          ),

          // Bottom padding for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    ),

        // FAB to add devices
        Positioned(
          right: 20,
          bottom: 96,
          child: FloatingActionButton(
            heroTag: 'add_device_fab',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddDeviceScreen(),
                ),
              );
            },
            backgroundColor: AppColors.electricCyan,
            elevation: 8,
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}
