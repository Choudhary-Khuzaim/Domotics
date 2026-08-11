import 'dart:async';
import 'dart:math';
import '../models/ble_device.dart';

/// Simulated Bluetooth Low Energy scanning service.
/// Produces a stream of mock BLE devices with randomized RSSI values.
class MockBleService {
  static final List<BleDevice> _devicePool = [
    BleDevice(
      id: 'ble_1',
      name: 'Living_Room_AC_BLE',
      macAddress: 'A4:C1:38:7D:2E:01',
      rssi: -45,
    ),
    BleDevice(
      id: 'ble_2',
      name: 'Philips_Hue_Strip',
      macAddress: 'B8:27:EB:3A:F1:12',
      rssi: -52,
    ),
    BleDevice(
      id: 'ble_3',
      name: 'Smart_Lock_V2',
      macAddress: 'DC:A6:32:1C:44:23',
      rssi: -61,
    ),
    BleDevice(
      id: 'ble_4',
      name: 'Samsung_TV_BLE',
      macAddress: 'E4:5F:01:8B:9C:34',
      rssi: -38,
    ),
    BleDevice(
      id: 'ble_5',
      name: 'Nest_Thermostat',
      macAddress: 'F0:18:98:4D:B2:45',
      rssi: -73,
    ),
    BleDevice(
      id: 'ble_6',
      name: 'Ring_Doorbell',
      macAddress: '1A:2B:3C:4D:5E:56',
      rssi: -85,
    ),
    BleDevice(
      id: 'ble_7',
      name: 'Echo_Dot_BLE',
      macAddress: '2C:4A:6E:8F:A1:67',
      rssi: -58,
    ),
    BleDevice(
      id: 'ble_8',
      name: 'Dyson_Fan_Link',
      macAddress: '3D:5B:7F:9A:C2:78',
      rssi: -67,
    ),
  ];

  final Random _random = Random();

  /// Returns a stream that emits discovered devices one by one.
  /// Each device is emitted at a random interval (500ms – 1500ms).
  Stream<BleDevice> scanForDevices() async* {
    final shuffled = List<BleDevice>.from(_devicePool)..shuffle(_random);

    for (final device in shuffled) {
      await Future.delayed(
        Duration(milliseconds: 600 + _random.nextInt(900)),
      );

      // Add slight RSSI variation on each scan
      final rssiVariation = _random.nextInt(10) - 5;
      yield device.copyWith(rssi: device.rssi + rssiVariation);
    }
  }

  /// Simulates a BLE connection attempt (2 second delay).
  Future<bool> connect(String deviceId) async {
    await Future.delayed(const Duration(seconds: 2));
    // 90% success rate
    return _random.nextDouble() < 0.9;
  }

  /// Simulates PIN-based pairing. Validates against PIN "1234".
  Future<bool> pair(String deviceId, String pin) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return pin == '1234';
  }
}
