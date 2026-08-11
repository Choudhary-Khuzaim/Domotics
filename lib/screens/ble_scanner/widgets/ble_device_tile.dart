import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/ble_device.dart';
import '../../../widgets/glass_card.dart';

/// List tile for a discovered BLE device with signal bars and connection state.
class BleDeviceTile extends StatelessWidget {
  final BleDevice device;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final VoidCallback onPair;

  const BleDeviceTile({
    super.key,
    required this.device,
    required this.onConnect,
    required this.onDisconnect,
    required this.onPair,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      isActive: device.connectionState == BleConnectionState.connected ||
          device.connectionState == BleConnectionState.paired,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Device icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getStateColor().withOpacity(0.12),
            ),
            child: Icon(
              Icons.bluetooth,
              size: 22,
              color: _getStateColor(),
            ),
          ),
          const SizedBox(width: 14),

          // Name, MAC, status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  device.macAddress,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Signal bars
                    _buildSignalBars(isDark),
                    const SizedBox(width: 8),
                    Text(
                      '${device.rssi} dBm',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Action button
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildSignalBars(bool isDark) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index < device.signalBars;
        return Container(
          width: 4,
          height: 6.0 + (index * 3),
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: isActive
                ? AppColors.electricCyan
                : isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
          ),
        );
      }),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    switch (device.connectionState) {
      case BleConnectionState.disconnected:
        return _actionButton(
          context,
          'Connect',
          AppColors.electricCyan,
          onConnect,
        );
      case BleConnectionState.connecting:
        return SizedBox(
          width: 80,
          height: 34,
          child: Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.electricCyan),
              ),
            ),
          ),
        );
      case BleConnectionState.connected:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionButton(context, 'Pair', AppColors.neonIndigo, onPair),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDisconnect,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.accentRose.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.accentRose,
                ),
              ),
            ),
          ],
        );
      case BleConnectionState.paired:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.accentGreen.withOpacity(0.12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 14, color: AppColors.accentGreen),
              const SizedBox(width: 4),
              const Text(
                'Paired',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _actionButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  Color _getStateColor() {
    switch (device.connectionState) {
      case BleConnectionState.disconnected:
        return AppColors.darkTextMuted;
      case BleConnectionState.connecting:
        return AppColors.accentAmber;
      case BleConnectionState.connected:
        return AppColors.electricCyan;
      case BleConnectionState.paired:
        return AppColors.accentGreen;
    }
  }
}
