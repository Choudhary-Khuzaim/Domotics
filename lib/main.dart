import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'providers/device_provider.dart';
import 'providers/ble_scan_provider.dart';
import 'providers/energy_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/scene_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/scenes/scenes_screen.dart';
import 'screens/ble_scanner/ble_scanner_screen.dart';
import 'screens/analytics/analytics_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DomoticsApp());
}

class DomoticsApp extends StatelessWidget {
  const DomoticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => BleScanProvider()),
        ChangeNotifierProvider(create: (_) => EnergyProvider()),
        ChangeNotifierProvider(create: (_) => SceneProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Domotics',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}

/// Root scaffold with bottom navigation managing four main screens.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    ScenesScreen(),
    BleScannerScreen(),
    AnalyticsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
