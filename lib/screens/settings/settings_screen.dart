import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/device_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/glass_card.dart';
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
                    MaterialPageRoute(
                        builder: (_) => const ProfileScreen()),
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
                          MaterialPageRoute(
                              builder: (_) => const RoomsScreen()),
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
                          MaterialPageRoute(
                              builder: (_) =>
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
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      iconColor: AppColors.neonIndigo,
                      title: 'Terms of Service',
                      subtitle: '',
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: AppColors.accentAmber,
                      title: 'Privacy Policy',
                      subtitle: '',
                      onTap: () {},
                    ),
                    _divider(isDark),
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      iconColor: AppColors.accentGreen,
                      title: 'Help & Support',
                      subtitle: '',
                      onTap: () {},
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
