import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_ext.dart';
import '../../../core/theme/theme_ext.dart';
import '../../viewmodels/timer_viewmodel.dart';
import '../../widgets/close_app_dialog.dart';
import '../congratulation/congratulation_screen.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CloseAppDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TimerViewModel>();

    // Route to Congratulation screen if workout completed
    if (viewModel.currentPhase == WorkoutPhase.completed) {
      Future.delayed(Duration.zero, () {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CongratulationScreen()),
          );
        }
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: context.bgBase,
        appBar: AppBar(
          backgroundColor: context.bgBase,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: context.textMuted,
              size: 32,
            ),
            onPressed: () async {
              final shouldPop = await _onWillPop(context);
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            context.translate('title'),
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildPhaseBar(context, viewModel),
              const SizedBox(height: 10),
              _buildRoundRow(context, viewModel),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WorkoutProgressWidget(
                      secondsRemaining: viewModel.secondsRemaining,
                      phaseDuration: viewModel.phaseDuration,
                      phase: viewModel.currentPhase,
                    ),
                  ],
                ),
              ),
              _buildNextRow(context, viewModel),
              const SizedBox(height: 20),
              _buildControlBar(context, viewModel),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseBar(BuildContext context, TimerViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.translate('preparation').toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: context.prep,
                ),
              ),
              Text(
                context.translate('workout').toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: context.workout,
                ),
              ),
              Text(
                context.translate('rest').toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: context.rest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.bgSurface3,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _calculatePhaseProgress(viewModel),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [context.prepLight, context.workoutLight],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePhaseProgress(TimerViewModel viewModel) {
    switch (viewModel.currentPhase) {
      case WorkoutPhase.prep:
        return 0.15;
      case WorkoutPhase.workout:
        return 0.50;
      case WorkoutPhase.rest:
        return 0.85;
      case WorkoutPhase.completed:
        return 1.0;
    }
  }

  Widget _buildRoundRow(BuildContext context, TimerViewModel viewModel) {
    List<Widget> dots = [];
    for (int i = 1; i <= viewModel.totalRounds; i++) {
      dots.add(Expanded(
        child: Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: i <= viewModel.currentRound ? context.accent : context.bgSurface3,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Row(children: dots)),
          const SizedBox(width: 12),
          Text(
            "${viewModel.currentRound} / ${viewModel.totalRounds}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: context.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextRow(BuildContext context, TimerViewModel viewModel) {
    String nextLabel = '';
    String nextVal = '';
    Color nextColor = Colors.transparent;

    if (viewModel.currentPhase == WorkoutPhase.prep) {
      nextLabel = 'Next: ${context.translate('workout')}';
      nextVal = _formatDuration(viewModel.workoutSeconds);
      nextColor = context.workout;
    } else if (viewModel.currentPhase == WorkoutPhase.workout) {
      if (viewModel.currentRound < viewModel.totalRounds) {
        nextLabel = 'Next: ${context.translate('rest')}';
        nextVal = _formatDuration(viewModel.restSeconds);
        nextColor = context.rest;
      } else {
        nextLabel = 'Next: Finish';
        nextVal = '--:--';
        nextColor = context.accentLight;
      }
    } else if (viewModel.currentPhase == WorkoutPhase.rest) {
      nextLabel = 'Next: ${context.translate('workout')}';
      nextVal = _formatDuration(viewModel.workoutSeconds);
      nextColor = context.workout;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildNextBox(
              context,
              label: nextLabel,
              value: nextVal,
              color: nextColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildNextBox(
              context,
              label: 'Round ${viewModel.currentRound + 1}',
              value: viewModel.currentRound < viewModel.totalRounds
                  ? _formatDuration(viewModel.workoutSeconds)
                  : '--:--',
              color: context.workout,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  Widget _buildNextBox(BuildContext context, {required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: context.bgSurface,
        border: Border.all(color: context.borderSubtle),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: context.textMuted),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar(BuildContext context, TimerViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip Button
        GestureDetector(
          onTap: () => viewModel.skipPhase(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.bgSurface,
              border: Border.all(color: context.borderSubtle),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.skip_next_rounded,
              color: context.textPrimary,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Play/Pause Button
        GestureDetector(
          onTap: () => viewModel.togglePause(),
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [context.accent, context.accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.accent.withOpacity(0.45),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              viewModel.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(width: 72), // Maintain spacing balance
      ],
    );
  }
}

class WorkoutProgressWidget extends StatefulWidget {
  final int secondsRemaining;
  final int phaseDuration;
  final WorkoutPhase phase;

  const WorkoutProgressWidget({
    super.key,
    required this.secondsRemaining,
    required this.phaseDuration,
    required this.phase,
  });

  @override
  State<WorkoutProgressWidget> createState() => _WorkoutProgressWidgetState();
}

class _WorkoutProgressWidgetState extends State<WorkoutProgressWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
  }

  @override
  void didUpdateWidget(covariant WorkoutProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining && widget.secondsRemaining <= 3) {
      _animationController.forward(from: 0.0).then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getPhaseLabel(BuildContext context) {
    switch (widget.phase) {
      case WorkoutPhase.prep:
        return context.translate('preparation');
      case WorkoutPhase.workout:
        return context.translate('workout');
      case WorkoutPhase.rest:
        return context.translate('rest');
      case WorkoutPhase.completed:
        return context.translate('done');
    }
  }

  Color _getPhaseColor(BuildContext context) {
    switch (widget.phase) {
      case WorkoutPhase.prep:
        return context.prep;
      case WorkoutPhase.workout:
        return context.workout;
      case WorkoutPhase.rest:
        return context.rest;
      case WorkoutPhase.completed:
        return context.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPhaseColor(context);
    final progressVal = widget.phaseDuration > 0 ? widget.secondsRemaining / widget.phaseDuration : 0.0;

    return Column(
      children: [
        _buildPhaseChip(context, color),
        const SizedBox(height: 14),
        SizedBox(
          height: 220,
          width: 220,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.12),
                      context.bgBase.withOpacity(0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 0.7],
                  ),
                ),
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(widget.secondsRemaining > 3 ? color : context.error),
                backgroundColor: context.ringTrack,
                strokeWidth: 14,
                strokeCap: StrokeCap.round,
                value: progressVal,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _getPhaseLabel(context).toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                        color: color,
                      ),
                    ),
                    ScaleTransition(
                      scale: _bounceAnimation,
                      child: Text(
                        '${widget.secondsRemaining}',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      context.translate('seconds').toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.5,
                        color: context.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhaseChip(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _getPhaseLabel(context).toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
