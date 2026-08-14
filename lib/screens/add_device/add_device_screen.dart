import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../../models/smart_device.dart';
import '../../providers/device_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/glass_card.dart';

/// Multi-step add device flow.
class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  DeviceType? _selectedType;
  String _deviceName = '';
  String _selectedRoom = 'Living Room';

  late AnimationController _successController;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Text(
                    'Add Device',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Step indicator
                  Text(
                    'Step ${_currentStep + 1} of 3',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.electricCyan),
                  minHeight: 4,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Step content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentStep == 0
                    ? _buildTypeSelection(isDark)
                    : _currentStep == 1
                        ? _buildNameAndRoom(isDark)
                        : _buildConfirmation(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 1: Select Device Type ──────────────────────────────────

  Widget _buildTypeSelection(bool isDark) {
    final types = [
      _DeviceTypeOption(
        type: DeviceType.light,
        name: 'Smart Light',
        icon: Icons.lightbulb_outline,
        color: AppColors.accentAmber,
      ),
      _DeviceTypeOption(
        type: DeviceType.ac,
        name: 'Air Conditioner',
        icon: Icons.ac_unit,
        color: AppColors.electricCyan,
      ),
      _DeviceTypeOption(
        type: DeviceType.fan,
        name: 'Smart Fan',
        icon: Icons.air_rounded,
        color: AppColors.accentGreen,
      ),
      _DeviceTypeOption(
        type: DeviceType.lock,
        name: 'Smart Lock',
        icon: Icons.lock_outline,
        color: AppColors.accentRose,
      ),
      _DeviceTypeOption(
        type: DeviceType.tv,
        name: 'Smart TV',
        icon: Icons.tv,
        color: AppColors.neonIndigo,
      ),
      _DeviceTypeOption(
        type: DeviceType.camera,
        name: 'Security Camera',
        icon: Icons.videocam_outlined,
        color: const Color(0xFF3B82F6),
      ),
      _DeviceTypeOption(
        type: DeviceType.speaker,
        name: 'Smart Speaker',
        icon: Icons.speaker_group_outlined,
        color: AppColors.accentViolet,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What type of device?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Select the type of smart device to add',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
              ),
              itemCount: types.length,
              itemBuilder: (context, index) {
                final option = types[index];
                final isSelected = _selectedType == option.type;

                return GlassCard(
                  isActive: isSelected,
                  activeGlowColor: option.color,
                  onTap: () {
                    setState(() => _selectedType = option.type);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: option.color.withOpacity(
                              isSelected ? 0.2 : 0.1),
                        ),
                        child: Icon(
                          option.icon,
                          color: option.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? option.color
                              : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Next button
          _buildBottomButton(
            'Next',
            _selectedType != null
                ? () => setState(() => _currentStep = 1)
                : null,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Step 2: Name & Room ─────────────────────────────────────────

  Widget _buildNameAndRoom(bool isDark) {
    final roomProvider = context.watch<RoomProvider>();
    final controller = TextEditingController(text: _deviceName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Give your device a name and assign it to a room',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Name field
          GlassCard(
            child: TextField(
              controller: controller,
              onChanged: (v) => _deviceName = v,
              decoration: InputDecoration(
                hintText: 'Device name',
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  _getDeviceIcon(_selectedType!),
                  color: AppColors.electricCyan,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Room selection
          Text(
            'SELECT ROOM',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: ListView.separated(
              itemCount: roomProvider.rooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final room = roomProvider.rooms[index];
                final isSelected = _selectedRoom == room.name;

                return GlassCard(
                  isActive: isSelected,
                  activeGlowColor: AppColors.electricCyan,
                  onTap: () {
                    setState(() => _selectedRoom = room.name);
                  },
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        room.icon,
                        color: isSelected
                            ? AppColors.electricCyan
                            : isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        room.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.electricCyan
                              : null,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.electricCyan,
                          size: 20,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Buttons
          Row(
            children: [
              Expanded(
                child: _buildBottomButton(
                  'Back',
                  () => setState(() => _currentStep = 0),
                  isSecondary: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBottomButton(
                  'Add Device',
                  _deviceName.trim().isNotEmpty
                      ? () {
                          _addDevice();
                          setState(() => _currentStep = 2);
                          _successController.forward();
                        }
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Step 3: Confirmation ────────────────────────────────────────

  Widget _buildConfirmation(bool isDark) {
    return Center(
      child: ScaleTransition(
        scale: _successScale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGreen.withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGreen.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.accentGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Device Added!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$_deviceName" has been added to $_selectedRoom',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _buildBottomButton(
                'Done',
                () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(String label, VoidCallback? onTap,
      {bool isSecondary = false}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? Colors.transparent
              : AppColors.electricCyan,
          foregroundColor: isSecondary
              ? AppColors.electricCyan
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isSecondary
                ? const BorderSide(color: AppColors.electricCyan)
                : BorderSide.none,
          ),
          disabledBackgroundColor: AppColors.darkSurfaceVariant.withOpacity(0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: onTap == null
                ? AppColors.darkTextMuted
                : isSecondary
                    ? AppColors.electricCyan
                    : Colors.white,
          ),
        ),
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_outline;
      case DeviceType.ac:
        return Icons.ac_unit;
      case DeviceType.fan:
        return Icons.air_rounded;
      case DeviceType.lock:
        return Icons.lock_outline;
      case DeviceType.tv:
        return Icons.tv;
      case DeviceType.camera:
        return Icons.videocam_outlined;
      case DeviceType.speaker:
        return Icons.speaker_group_outlined;
    }
  }

  void _addDevice() {
    final deviceProvider = context.read<DeviceProvider>();
    final id = 'device_${DateTime.now().millisecondsSinceEpoch}';

    SmartDevice newDevice;
    switch (_selectedType!) {
      case DeviceType.light:
        newDevice = SmartLight(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
      case DeviceType.ac:
        newDevice = SmartAC(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
      case DeviceType.fan:
        newDevice = SmartFan(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
      case DeviceType.lock:
        newDevice = SmartLock(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
      case DeviceType.tv:
        newDevice = SmartTV(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
      case DeviceType.camera:
        newDevice = SmartCamera(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
      case DeviceType.speaker:
        newDevice = SmartSpeaker(
            id: id, name: _deviceName, room: _selectedRoom, isActive: false);
        break;
    }

    deviceProvider.addDevice(newDevice);
  }
}

class _DeviceTypeOption {
  final DeviceType type;
  final String name;
  final IconData icon;
  final Color color;

  const _DeviceTypeOption({
    required this.type,
    required this.name,
    required this.icon,
    required this.color,
  });
}
