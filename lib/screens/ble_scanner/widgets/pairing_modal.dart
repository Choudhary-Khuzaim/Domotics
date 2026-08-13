import 'package:flutter/material.dart';
import '../../../app_theme.dart';

/// Bottom sheet modal for PIN-based BLE device pairing.
class PairingModal extends StatefulWidget {
  final String deviceName;
  final Future<bool> Function(String pin) onPair;

  const PairingModal({
    super.key,
    required this.deviceName,
    required this.onPair,
  });

  @override
  State<PairingModal> createState() => _PairingModalState();
}

class _PairingModalState extends State<PairingModal> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isPairing = false;
  bool? _pairResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _pin => _controllers.map((c) => c.text).join();

  Future<void> _handlePair() async {
    if (_pin.length != 4) return;

    setState(() {
      _isPairing = true;
      _pairResult = null;
    });

    final success = await widget.onPair(_pin);

    if (!mounted) return;

    setState(() {
      _isPairing = false;
      _pairResult = success;
    });

    if (success) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.glassBorder : AppColors.glassBorderLight,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.bluetooth_connected,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Pair with Device',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            widget.deviceName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.electricCyan,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the 4-digit PIN code',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 28),

          // PIN input boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 56,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurfaceVariant.withOpacity(0.5)
                        : AppColors.lightSurfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.glassBorder
                            : AppColors.glassBorderLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.glassBorder
                            : AppColors.glassBorderLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.electricCyan,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 3) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                    setState(() {}); // Refresh pair button state
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Result feedback
          if (_pairResult != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _pairResult!
                    ? AppColors.accentGreen.withOpacity(0.12)
                    : AppColors.accentRose.withOpacity(0.12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _pairResult! ? Icons.check_circle : Icons.error,
                    size: 18,
                    color: _pairResult!
                        ? AppColors.accentGreen
                        : AppColors.accentRose,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _pairResult!
                        ? 'Paired successfully!'
                        : 'Invalid PIN. Try again.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _pairResult!
                          ? AppColors.accentGreen
                          : AppColors.accentRose,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Pair button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _pin.length == 4 && !_isPairing ? _handlePair : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricCyan,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isPairing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      'Pair Device',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 8),

          // Hint
          Text(
            'Hint: Default PIN is 1234',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
