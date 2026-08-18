import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_transitions.dart';
import '../profile/profile_screen.dart';
import '../rooms/rooms_screen.dart';
import '../ble_scanner/ble_scanner_screen.dart';

/// Full settings screen with all app configuration options.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                    ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Customize your smart home experience',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),

          // ─── Profile Card ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                onTap: () {
                  Navigator.of(context).push(
                    SlideUpRoute(
                        page: const ProfileScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.electricCyan.withOpacity(0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          settings.userName.isNotEmpty
                              ? settings.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settings.userName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            settings.userEmail,
                            style:
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ─── Home Configuration ─────────────────────────────────────
          _buildSectionHeader(context, 'Home Configuration'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.home_rounded,
                      iconColor: AppColors.electricCyan,
                      title: 'Home Name',
                      subtitle: settings.homeName,
                      onTap: () => _showEditDialog(
                        context,
                        'Home Name',
                        settings.homeName,
                        settings.updateHomeName,
                      ),
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.accentAmber,
                      title: 'Address',
                      subtitle: settings.homeAddress,
                      onTap: () => _showEditDialog(
                        context,
                        'Home Address',
                        settings.homeAddress,
                        settings.updateHomeAddress,
                      ),
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.meeting_room_rounded,
                      iconColor: AppColors.neonIndigo,
                      title: 'Manage Rooms',
                      subtitle:
                          '${context.watch<RoomProvider>().rooms.length} rooms',
                      onTap: () {
                        Navigator.of(context).push(
                          SlideUpRoute(
                              page: const RoomsScreen()),
                        );
                      },
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.bluetooth_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      title: 'Connected Devices',
                      subtitle:
                          '${context.watch<DeviceProvider>().devices.length} devices',
                      onTap: () {
                        Navigator.of(context).push(
                          SlideUpRoute(
                              page:
                                  const BleScannerScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ─── Notifications ──────────────────────────────────────────
          _buildSectionHeader(context, 'Notifications'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsToggle(
                      icon: Icons.notifications_rounded,
                      iconColor: AppColors.electricCyan,
                      title: 'Push Notifications',
                      value: settings.pushNotifications,
                      onChanged: (_) =>
                          settings.togglePushNotifications(),
                    ),
                    _divider(isDark),
                    _SettingsToggle(
                      icon: Icons.volume_up_rounded,
                      iconColor: AppColors.accentAmber,
                      title: 'Sound',
                      value: settings.soundEnabled,
                      onChanged: (_) => settings.toggleSound(),
                    ),
                    _divider(isDark),
                    _SettingsToggle(
                      icon: Icons.email_rounded,
                      iconColor: AppColors.neonIndigo,
                      title: 'Email Notifications',
                      value: settings.emailNotifications,
                      onChanged: (_) =>
                          settings.toggleEmailNotifications(),
                    ),
                    _divider(isDark),
                    _SettingsToggle(
                      icon: Icons.shield_rounded,
                      iconColor: AppColors.accentRose,
                      title: 'Security Alerts',
                      value: settings.securityAlerts,
                      onChanged: (_) =>
                          settings.toggleSecurityAlerts(),
                    ),
                    _divider(isDark),
                    _SettingsToggle(
                      icon: Icons.bolt_rounded,
                      iconColor: AppColors.accentGreen,
                      title: 'Energy Alerts',
                      value: settings.energyAlerts,
                      onChanged: (_) => settings.toggleEnergyAlerts(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ─── Security & Privacy ─────────────────────────────────────
          _buildSectionHeader(context, 'Security & Privacy'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsToggle(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppColors.accentViolet,
                      title: 'Biometric Lock',
                      value: settings.biometricLock,
                      onChanged: (_) =>
                          settings.toggleBiometricLock(),
                    ),
                    _divider(isDark),
                    _SettingsToggle(
                      icon: Icons.pin_rounded,
                      iconColor: AppColors.accentAmber,
                      title: 'PIN Lock',
                      value: settings.pinLock,
                      onChanged: (_) => settings.togglePinLock(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ─── Appearance & Energy ────────────────────────────────────
          _buildSectionHeader(context, 'Preferences'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsToggle(
                      icon: isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      iconColor: AppColors.accentAmber,
                      title: 'Dark Mode',
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                    ),
                    _divider(isDark),
                    _SettingsToggle(
                      icon: Icons.thermostat_rounded,
                      iconColor: AppColors.accentRose,
                      title: 'Temperature in °C',
                      value: settings.useCelsius,
                      onChanged: (_) =>
                          settings.toggleTemperatureUnit(),
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.attach_money_rounded,
                      iconColor: AppColors.accentGreen,
                      title: 'Energy Rate',
                      subtitle:
                          '${settings.currency} ${settings.energyRate.toStringAsFixed(1)}/kWh',
                      onTap: () => _showEnergyRateDialog(
                          context, settings),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ─── About ──────────────────────────────────────────────────
          _buildSectionHeader(context, 'About'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.electricCyan,
                      title: 'App Version',
                      subtitle: 'v${settings.appVersion}',
                      onTap: () => _showAppInfoDialog(context, settings),
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      iconColor: AppColors.neonIndigo,
                      title: 'Terms of Service',
                      subtitle: '',
                      onTap: () => _showLegalSheet(context, 'Terms of Service', _termsOfServiceText),
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: AppColors.accentAmber,
                      title: 'Privacy Policy',
                      subtitle: '',
                      onTap: () => _showLegalSheet(context, 'Privacy Policy', _privacyPolicyText),
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      iconColor: AppColors.accentGreen,
                      title: 'Help & Support',
                      subtitle: '',
                      onTap: () => _showHelpSupportDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // ─── Logout Button ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                onTap: () {
                  _showLogoutDialog(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded,
                        color: AppColors.accentRose, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: AppColors.accentRose,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkTextMuted
                : AppColors.lightTextMuted,
          ),
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 56,
      color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
    );
  }

  void _showEditDialog(BuildContext context, String title,
      String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.electricCyan, width: 2),
            ),
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
              onSave(controller.text);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.electricCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEnergyRateDialog(
      BuildContext context, SettingsProvider settings) {
    final controller =
        TextEditingController(text: settings.energyRate.toStringAsFixed(1));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Energy Rate'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Rate per kWh',
            suffixText: '${settings.currency}/kWh',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.electricCyan, width: 2),
            ),
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
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                settings.setEnergyRate(val);
              }
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.electricCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
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
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentRose,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Log Out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── About Section Dialogs ──────────────────────────────────────

  static const String _termsOfServiceText = '''
Terms of Service — Domotics Smart Home App
Last Updated: August 2026

1. ACCEPTANCE OF TERMS
By accessing and using the Domotics application ("App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.

2. DESCRIPTION OF SERVICE
Domotics provides a smart home automation interface that allows users to control, monitor, and manage connected smart devices within their home environment.

3. USER ACCOUNTS
You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

4. DEVICE COMPATIBILITY
Domotics is designed to work with compatible smart home devices. We do not guarantee compatibility with all devices and are not responsible for any issues arising from incompatible hardware.

5. DATA COLLECTION
We collect usage data to improve the App experience. Please refer to our Privacy Policy for detailed information about data collection and usage.

6. INTELLECTUAL PROPERTY
All content, features, and functionality of the App are owned by Domotics and are protected by international copyright, trademark, and other intellectual property laws.

7. LIMITATION OF LIABILITY
Domotics shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the App.

8. MODIFICATIONS
We reserve the right to modify these terms at any time. Continued use of the App after modifications constitutes acceptance of the updated terms.

9. GOVERNING LAW
These terms shall be governed by and construed in accordance with applicable local laws.

10. CONTACT
For questions about these Terms, contact us at support@domotics.app.
''';

  static const String _privacyPolicyText = '''
Privacy Policy — Domotics Smart Home App
Last Updated: August 2026

1. INFORMATION WE COLLECT
• Device information (device type, model, operating system)
• Usage data (features used, interaction patterns)
• Smart home device data (device names, room assignments, usage schedules)
• Account information (name, email address)

2. HOW WE USE YOUR INFORMATION
• To provide and maintain the App
• To improve and personalize user experience
• To send important notifications about your smart home
• To analyze usage patterns for product improvement
• To provide energy consumption analytics

3. DATA STORAGE
Your data is stored locally on your device. In future versions with cloud sync, data will be encrypted and stored on secure servers.

4. DATA SHARING
We do not sell, trade, or rent your personal information to third parties. We may share anonymized, aggregated data for analytical purposes.

5. SECURITY
We implement industry-standard security measures including encryption, biometric authentication support, and PIN lock features to protect your data.

6. YOUR RIGHTS
• Access your personal data
• Request data deletion
• Export your home configuration data
• Opt out of non-essential notifications

7. CHILDREN'S PRIVACY
The App is not intended for children under 13. We do not knowingly collect personal information from children.

8. COOKIES & TRACKING
The App does not use cookies. We use minimal analytics to understand feature usage.

9. CHANGES TO THIS POLICY
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the App.

10. CONTACT US
If you have questions about this Privacy Policy, contact us at privacy@domotics.app.
''';

  void _showAppInfoDialog(BuildContext context, SettingsProvider settings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricCyan.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'Domotics',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Smart Living, Simplified',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 20),
            _infoRow('Version', 'v${settings.appVersion}', isDark),
            _infoRow('Build', '2026.08.16', isDark),
            _infoRow('Platform', 'Flutter / Dart', isDark),
            _infoRow('License', 'MIT License', isDark),
            const SizedBox(height: 16),
            Text(
              '© 2026 Khuzaim. All rights reserved.',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.electricCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Close',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalSheet(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    title.contains('Terms')
                        ? Icons.description_outlined
                        : Icons.privacy_tip_outlined,
                    color: title.contains('Terms')
                        ? AppColors.neonIndigo
                        : AppColors.accentAmber,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final faqs = [
      {
        'q': 'How do I add a new device?',
        'a': 'Tap the + button on the Dashboard to start the Add Device wizard. Select device type, give it a name, and assign it to a room.',
      },
      {
        'q': 'How do I create a scene?',
        'a': 'Go to the Scenes tab and tap the + button. Name your scene, choose an icon and gradient, then save.',
      },
      {
        'q': 'How do I set up a routine?',
        'a': 'Navigate to the Routines tab and tap the + button. Set a time, select repeat days, and optionally link a scene.',
      },
      {
        'q': 'How do I pair BLE devices?',
        'a': 'Go to Settings → Connected Devices. Tap Start Scan, then connect to a discovered device and enter PIN 1234 to pair.',
      },
      {
        'q': 'How do I change the energy rate?',
        'a': 'Go to Settings → Preferences → Energy Rate. Enter your local electricity rate per kWh.',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.help_outline_rounded,
                      color: AppColors.accentGreen),
                  const SizedBox(width: 10),
                  Text(
                    'Help & Support',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Text(
                    'FREQUENTLY ASKED QUESTIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...faqs.map((faq) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      border: Border.all(
                        color: isDark
                            ? AppColors.glassBorder
                            : AppColors.glassBorderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.quiz_rounded,
                                size: 18, color: AppColors.electricCyan),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                faq['q']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          faq['a']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.email_rounded,
                            color: Colors.white, size: 22),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need more help?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Contact us at support@domotics.app',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A settings tile with icon, title, subtitle, and chevron.
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: iconColor.withOpacity(0.12),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color:
                  isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}

/// A settings toggle tile with icon, title, and switch.
class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: iconColor.withOpacity(0.12),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
