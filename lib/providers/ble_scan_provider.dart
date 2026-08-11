import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ble_device.dart';
import '../services/mock_ble_service.dart';

/// Manages BLE scanning state and device connections.
class BleScanProvider extends ChangeNotifier {
  final MockBleService _bleService = MockBleService();

  bool _isScanning = false;
  final List<BleDevice> _discoveredDevices = [];
  StreamSubscription<BleDevice>? _scanSubscription;

  bool get isScanning => _isScanning;
  List<BleDevice> get discoveredDevices => _discoveredDevices;

  /// Start scanning for nearby BLE devices.
  void startScan() {
    if (_isScanning) return;

    _isScanning = true;
    _discoveredDevices.clear();
    notifyListeners();

    _scanSubscription = _bleService.scanForDevices().listen(
      (device) {
        // Avoid duplicates
        if (!_discoveredDevices.any((d) => d.id == device.id)) {
          _discoveredDevices.add(device);
          notifyListeners();
        }
      },
      onDone: () {
        _isScanning = false;
        notifyListeners();
      },
    );
  }

  /// Stop an ongoing scan.
  void stopScan() {
    _scanSubscription?.cancel();
    _isScanning = false;
    notifyListeners();
  }

  /// Connect to a discovered device by ID.
  Future<void> connectToDevice(String deviceId) async {
    final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
    if (index == -1) return;

    // Set to "connecting"
    _discoveredDevices[index] = _discoveredDevices[index].copyWith(
      connectionState: BleConnectionState.connecting,
    );
    notifyListeners();

    final success = await _bleService.connect(deviceId);

    _discoveredDevices[index] = _discoveredDevices[index].copyWith(
      connectionState:
          success
              ? BleConnectionState.connected
              : BleConnectionState.disconnected,
    );
    notifyListeners();
  }

  /// Disconnect a device.
  void disconnectDevice(String deviceId) {
    final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
    if (index == -1) return;

    _discoveredDevices[index] = _discoveredDevices[index].copyWith(
      connectionState: BleConnectionState.disconnected,
    );
    notifyListeners();
  }

  /// Pair a device using a PIN code.
  Future<bool> pairWithPin(String deviceId, String pin) async {
    final success = await _bleService.pair(deviceId, pin);

    if (success) {
      final index = _discoveredDevices.indexWhere((d) => d.id == deviceId);
      if (index != -1) {
        _discoveredDevices[index] = _discoveredDevices[index].copyWith(
          connectionState: BleConnectionState.paired,
        );
        notifyListeners();
      }
    }

    return success;
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }
}
