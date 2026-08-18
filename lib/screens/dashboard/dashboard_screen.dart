import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/device_provider.dart';
import '../../screens/device_detail/device_detail_screen.dart';
import '../../screens/add_device/add_device_screen.dart';
import '../../widgets/page_transitions.dart';
import 'widgets/greeting_header.dart';
import 'widgets/room_tabs.dart';
import 'widgets/device_card.dart';
import 'widgets/quick_scene_bar.dart';
import 'widgets/master_controls_card.dart';
import 'widgets/air_quality_card.dart';
import 'widgets/security_status_card.dart';
import 'widgets/home_status_card.dart';
import 'widgets/favorites_row.dart';

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

          // Home Status Summary Card
          const SliverToBoxAdapter(
            child: HomeStatusCard(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // Security Status Card
          const SliverToBoxAdapter(
            child: SecurityStatusCard(),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 14)),

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

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Favorites Row
          const SliverToBoxAdapter(
            child: FavoritesRow(),
          ),

          // Active devices count & My Home section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                  // Search button
                  GestureDetector(
                    onTap: () => _showSearchSheet(context, deviceProvider),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurfaceVariant,
                        border: Border.all(
                          color: isDark
                              ? AppColors.glassBorder
                              : AppColors.glassBorderLight,
                        ),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                              SlideUpRoute(
                                page: DeviceDetailScreen(
                                  deviceId: device.id,
                                ),
                              ),
                            );
                          },
                          onLongPress: () => _showDeleteDeviceDialog(
                            context, deviceProvider, device),
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
                SlideUpRoute(page: const AddDeviceScreen()),
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

  // ─── Search Sheet ──────────────────────────────────────────────
  void _showSearchSheet(BuildContext context, DeviceProvider deviceProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _DeviceSearchSheet(
          deviceProvider: deviceProvider,
          isDark: isDark,
        );
      },
    );
  }

  // ─── Delete Device Dialog ──────────────────────────────────────
  void _showDeleteDeviceDialog(
      BuildContext context, DeviceProvider deviceProvider, device) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded,
                color: AppColors.accentRose, size: 22),
            SizedBox(width: 10),
            Text('Remove Device'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${device.name}" from your home?\n\nThis action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                height: 1.4,
              ),
        ),
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
              deviceProvider.removeDevice(device.id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRose,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Remove',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Search overlay for finding devices by name, room, or type.
class _DeviceSearchSheet extends StatefulWidget {
  final DeviceProvider deviceProvider;
  final bool isDark;

  const _DeviceSearchSheet({
    required this.deviceProvider,
    required this.isDark,
  });

  @override
  State<_DeviceSearchSheet> createState() => _DeviceSearchSheetState();
}

class _DeviceSearchSheetState extends State<_DeviceSearchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final allDevices = widget.deviceProvider.devices;
    final filtered = _query.isEmpty
        ? allDevices
        : allDevices.where((d) {
            final q = _query.toLowerCase();
            return d.name.toLowerCase().contains(q) ||
                d.room.toLowerCase().contains(q) ||
                d.type.name.toLowerCase().contains(q);
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: widget.isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: widget.isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search devices, rooms...',
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.electricCyan),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: AppColors.electricCyan, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${filtered.length} result${filtered.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Results
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final device = filtered[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        SlideUpRoute(
                          page: DeviceDetailScreen(deviceId: device.id),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    tileColor: widget.isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (device.isActive
                                ? AppColors.electricCyan
                                : widget.isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted)
                            .withOpacity(0.12),
                      ),
                      child: Icon(
                        device.icon,
                        size: 20,
                        color: device.isActive
                            ? AppColors.electricCyan
                            : widget.isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                      ),
                    ),
                    title: Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${device.room} · ${device.type.name}',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: device.isActive
                            ? AppColors.accentGreen.withOpacity(0.12)
                            : AppColors.accentRose.withOpacity(0.12),
                      ),
                      child: Text(
                        device.isActive ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: device.isActive
                              ? AppColors.accentGreen
                              : AppColors.accentRose,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
