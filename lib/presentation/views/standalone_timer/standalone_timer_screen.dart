import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_ext.dart';
import '../../../core/theme/theme_ext.dart';
import '../../viewmodels/standalone_timer_viewmodel.dart';
import '../settings/settings_screen.dart';
import '../../widgets/duration_picker_sheet.dart';

class StandaloneTimerScreen extends StatefulWidget {
  const StandaloneTimerScreen({super.key});

  @override
  State<StandaloneTimerScreen> createState() => _StandaloneTimerScreenState();
}

class _StandaloneTimerScreenState extends State<StandaloneTimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openDurationPicker(BuildContext context, StandaloneTimerViewModel vm) {
    if (vm.isRunning) return;
    DurationPickerSheet.show(
      context,
      initialDuration: vm.configuredDuration,
      onDurationSelected: (newDuration) {
        vm.setCountdownDuration(newDuration);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerViewModel = context.watch<StandaloneTimerViewModel>();

    if (timerViewModel.isCompleted) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }

    return Scaffold(
      backgroundColor: context.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              _buildTopBar(context),
              const SizedBox(height: 16),
              _buildModeSwitcher(context, timerViewModel),
              Expanded(
                child: Center(
                  child: _buildTimerDisplay(context, timerViewModel),
                ),
              ),
              _buildControls(context, timerViewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.textPrimary, size: 20),
              onPressed: () => Navigator.maybePop(context),
              tooltip: context.translate('back'),
            ),
            const SizedBox(width: 8),
            Text(
              context.translate('timer_title'),
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        IconButton(
          tooltip: context.translate('settings'),
          icon: Icon(
            Icons.tune_rounded,
            color: context.textPrimary,
            size: 22,
          ),
          style: IconButton.styleFrom(
            backgroundColor: context.bgSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: context.borderSubtle),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModeSwitcher(BuildContext context, StandaloneTimerViewModel vm) {
    final isCountdown = vm.mode == StandaloneTimerMode.countdown;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildModeSegment(
              context: context,
              title: context.translate('countdown'),
              isSelected: isCountdown,
              onTap: () => vm.setMode(StandaloneTimerMode.countdown),
            ),
          ),
          Expanded(
            child: _buildModeSegment(
              context: context,
              title: context.translate('stopwatch'),
              isSelected: !isCountdown,
              onTap: () => vm.setMode(StandaloneTimerMode.stopwatch),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSegment({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.accent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: isSelected ? context.fabForeground : context.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(BuildContext context, StandaloneTimerViewModel vm) {
    final isCountdown = vm.mode == StandaloneTimerMode.countdown;
    final isCompleted = vm.isCompleted;

    return GestureDetector(
      onTap: (isCountdown && !vm.isRunning) ? () => _openDurationPicker(context, vm) : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCompleted) ...[
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: context.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.accent, width: 1.5),
                ),
                child: Text(
                  context.translate('done').toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: context.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              vm.formattedTime,
              style: TextStyle(
                fontSize: 84,
                fontWeight: FontWeight.w900,
                color: isCompleted ? context.accent : context.textPrimary,
                letterSpacing: -2.0,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (isCountdown && !vm.isRunning && !isCompleted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderSubtle),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 14, color: context.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    context.translate('set_duration'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, StandaloneTimerViewModel vm) {
    if (vm.isIdle) {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(
          context: context,
          label: context.translate('start'),
          icon: Icons.play_arrow_rounded,
          isPrimary: true,
          onPressed: () => vm.start(),
        ),
      );
    } else if (vm.isRunning) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildActionButton(
              context: context,
              label: context.translate('reset'),
              icon: Icons.replay_rounded,
              isPrimary: false,
              onPressed: () => vm.reset(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: _buildActionButton(
              context: context,
              label: context.translate('pause'),
              icon: Icons.pause_rounded,
              isPrimary: true,
              onPressed: () => vm.pause(),
            ),
          ),
        ],
      );
    } else if (vm.isPaused) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildActionButton(
              context: context,
              label: context.translate('reset'),
              icon: Icons.replay_rounded,
              isPrimary: false,
              onPressed: () => vm.reset(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: _buildActionButton(
              context: context,
              label: context.translate('resume'),
              icon: Icons.play_arrow_rounded,
              isPrimary: true,
              onPressed: () => vm.resume(),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildActionButton(
              context: context,
              label: context.translate('reset'),
              icon: Icons.replay_rounded,
              isPrimary: false,
              onPressed: () => vm.reset(),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: _buildActionButton(
              context: context,
              label: context.translate('start'),
              icon: Icons.play_arrow_rounded,
              isPrimary: true,
              onPressed: () => vm.start(),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label.toUpperCase(),
          style: const TextStyle(
            inherit: false,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.accent,
          foregroundColor: context.fabForeground,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label.toUpperCase(),
          style: TextStyle(
            inherit: false,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: context.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.borderSubtle, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }
  }
}
