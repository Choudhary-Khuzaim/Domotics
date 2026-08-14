import 'package:flutter/material.dart';

/// Manages user preferences and app settings.
class SettingsProvider extends ChangeNotifier {
  // ─── User Profile ───────────────────────────────────────────────
  String _userName = 'Khuzaim';
  String _userEmail = 'khuzaim@domotics.app';
  String _homeName = 'My Smart Home';
  String _homeAddress = 'Islamabad, Pakistan';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get homeName => _homeName;
  String get homeAddress => _homeAddress;

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void updateUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void updateHomeName(String name) {
    _homeName = name;
    notifyListeners();
  }

  void updateHomeAddress(String address) {
    _homeAddress = address;
    notifyListeners();
  }

  // ─── Notification Preferences ───────────────────────────────────
  bool _pushNotifications = true;
  bool _soundEnabled = true;
  bool _emailNotifications = false;
  bool _securityAlerts = true;
  bool _energyAlerts = true;

  bool get pushNotifications => _pushNotifications;
  bool get soundEnabled => _soundEnabled;
  bool get emailNotifications => _emailNotifications;
  bool get securityAlerts => _securityAlerts;
  bool get energyAlerts => _energyAlerts;

  void togglePushNotifications() {
    _pushNotifications = !_pushNotifications;
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    notifyListeners();
  }

  void toggleEmailNotifications() {
    _emailNotifications = !_emailNotifications;
    notifyListeners();
  }

  void toggleSecurityAlerts() {
    _securityAlerts = !_securityAlerts;
    notifyListeners();
  }

  void toggleEnergyAlerts() {
    _energyAlerts = !_energyAlerts;
    notifyListeners();
  }

  // ─── Security & Privacy ─────────────────────────────────────────
  bool _biometricLock = false;
  bool _pinLock = false;

  bool get biometricLock => _biometricLock;
  bool get pinLock => _pinLock;

  void toggleBiometricLock() {
    _biometricLock = !_biometricLock;
    notifyListeners();
  }

  void togglePinLock() {
    _pinLock = !_pinLock;
    notifyListeners();
  }

  // ─── Energy Preferences ─────────────────────────────────────────
  String _currency = 'PKR';
  double _energyRate = 35.0; // per kWh
  bool _useCelsius = true;

  String get currency => _currency;
  double get energyRate => _energyRate;
  bool get useCelsius => _useCelsius;

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void setEnergyRate(double rate) {
    _energyRate = rate;
    notifyListeners();
  }

  void toggleTemperatureUnit() {
    _useCelsius = !_useCelsius;
    notifyListeners();
  }

  // ─── App Info ───────────────────────────────────────────────────
  final String appVersion = '1.0.0';
  final DateTime memberSince = DateTime(2024, 6, 15);
}
