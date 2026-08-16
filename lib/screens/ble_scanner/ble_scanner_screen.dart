import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/ble_device.dart';
import '../../providers/ble_scan_provider.dart';
import 'widgets/radar_animation.dart';
import 'widgets/ble_device_tile.dart';
import 'widgets/pairing_modal.dart';

/// BLE Scanner screen with radar animation and device discovery list.
class BleScannerScreen extends StatelessWidget {
  const BleScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bleProvider = context.watch<BleScanProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Back button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'Discover Nearby Devices',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),

          // Subtitle
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: Text(
                'Scan for smart devices via Bluetooth Low Energy',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),

          // Radar animation
          SliverToBoxAdapter(
            child: Center(
              child: RadarAnimation(
                isScanning: bleProvider.isScanning,
                discoveredCount: bleProvider.discoveredDevices.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Scan button
          SliverToBoxAdapter(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (bleProvider.isScanning) {
                    bleProvider.stopScan();
                  } else {
                    bleProvider.startScan();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: bleProvider.isScanning
                        ? null
                        : AppColors.primaryGradient,
                    color: bleProvider.isScanning
                        ? AppColors.accentRose.withOpacity(0.15)
                        : null,
                    border: bleProvider.isScanning
                        ? Border.all(
                            color: AppColors.accentRose.withOpacity(0.3),
                          )
                        : null,
                    boxShadow: bleProvider.isScanning
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.electricCyan.withOpacity(0.3),
                              blurRadius: 16,
                              spreadRadius: 0,
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        bleProvider.isScanning
                            ? Icons.stop_rounded
                            : Icons.bluetooth_searching_rounded,
                        color: bleProvider.isScanning
                            ? AppColors.accentRose
                            : Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bleProvider.isScanning ? 'Stop Scan' : 'Start Scan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: bleProvider.isScanning
                              ? AppColors.accentRose
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Discovered count
          if (bleProvider.discoveredDevices.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    Text(
                      'Found Devices',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.electricCyan.withOpacity(0.12),
                      ),
                      child: Text(
                        '${bleProvider.discoveredDevices.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.electricCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Device list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final device = bleProvider.discoveredDevices[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BleDeviceTile(
                      device: device,
                      onConnect: () =>
                          bleProvider.connectToDevice(device.id),
                      onDisconnect: () =>
                          bleProvider.disconnectDevice(device.id),
                      onPair: () => _showPairingModal(
                        context,
                        device,
                        bleProvider,
                      ),
                    ),
                  );
                },
                childCount: bleProvider.discoveredDevices.length,
              ),
            ),
          ),

          // Empty state
          if (bleProvider.discoveredDevices.isEmpty && !bleProvider.isScanning)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.bluetooth_disabled_rounded,
                      size: 48,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No devices found yet.\nTap "Start Scan" to begin.',
                      textAlign: TextAlign.center,
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

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
        ),
      ),
    );
  }

  void _showPairingModal(
    BuildContext context,
    BleDevice device,
    BleScanProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PairingModal(
        deviceName: device.name,
        onPair: (pin) => provider.pairWithPin(device.id, pin),
      ),
    );
  }
}
