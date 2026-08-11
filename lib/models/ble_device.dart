/// Connection states for BLE devices.
enum BleConnectionState { disconnected, connecting, connected, paired }

/// Model representing a discovered Bluetooth Low Energy device.
class BleDevice {
  final String id;
  final String name;
  final String macAddress;
  int rssi; // Signal strength in dBm (e.g., -30 to -90)
  BleConnectionState connectionState;

  BleDevice({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.rssi,
    this.connectionState = BleConnectionState.disconnected,
  });

  /// Returns a signal quality level from 0 (worst) to 4 (best).
  int get signalBars {
    if (rssi >= -50) return 4;
    if (rssi >= -60) return 3;
    if (rssi >= -70) return 2;
    if (rssi >= -80) return 1;
    return 0;
  }

  /// Human-readable connection status string.
  String get statusText {
    switch (connectionState) {
      case BleConnectionState.disconnected:
        return 'Disconnected';
      case BleConnectionState.connecting:
        return 'Connecting...';
      case BleConnectionState.connected:
        return 'Connected';
      case BleConnectionState.paired:
        return 'Paired';
    }
  }

  BleDevice copyWith({
    String? id,
    String? name,
    String? macAddress,
    int? rssi,
    BleConnectionState? connectionState,
  }) {
    return BleDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      macAddress: macAddress ?? this.macAddress,
      rssi: rssi ?? this.rssi,
      connectionState: connectionState ?? this.connectionState,
    );
  }
}
