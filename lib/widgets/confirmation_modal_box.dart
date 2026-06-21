import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/home_screen.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';

void showAlertDialog(BuildContext context, {int? elapsedSec, int? remainingSec}) {
  final homeProvider = Provider.of<Home>(context, listen: false);

  final currentRound = homeProvider.currentWorkoutStage;
  final totalRounds = homeProvider.totalWorkout;
  final totalSec = homeProvider.totalSec;

  final prepTime = homeProvider.prepMin * 60 + homeProvider.prepSec;
  final workoutTime = homeProvider.workoutMin * 60 + homeProvider.workoutSec;
  final restTime = homeProvider.restMin * 60 + homeProvider.restSec;

  int estimatedElapsed = 0;
  if (homeProvider.isPrepComplete) {
    // Prep is active
    estimatedElapsed = 0;
  } else {
    estimatedElapsed += prepTime;
    // We are at currentRound
    estimatedElapsed += (currentRound - 1) * (workoutTime + restTime);
    if (homeProvider.isRestComplete) {
      // Workout is done, Rest is active
      estimatedElapsed += workoutTime;
    }
  }

  final elapsed = elapsedSec ?? estimatedElapsed;
  final remaining = remainingSec ?? (totalSec - elapsed).clamp(0, totalSec);

  String _fmt(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim, anim2) {
      return _StopDialog(
        currentRound: currentRound,
        totalRounds: totalRounds,
        elapsedFormatted: _fmt(elapsed),
        remainingFormatted: _fmt(remaining),
        onKeepGoing: () => Navigator.of(ctx).pop(),
        onEndSession: () {
          homeProvider.changeIsPrepComplete(true);
          homeProvider.changeIsWorkoutComplete(false);
          homeProvider.changeIsRestComplete(false);

          Navigator.of(ctx).pop();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        },
      );
    },
    transitionBuilder: (ctx, anim, anim2, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

class _StopDialog extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final String elapsedFormatted;
  final String remainingFormatted;
  final VoidCallback onKeepGoing;
  final VoidCallback onEndSession;

  const _StopDialog({
    required this.currentRound,
    required this.totalRounds,
    required this.elapsedFormatted,
    required this.remainingFormatted,
    required this.onKeepGoing,
    required this.onEndSession,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Backdrop blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: context.bgBase.withOpacity(0.75),
              ),
            ),
          ),

          // Center modal
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
              decoration: BoxDecoration(
                color: context.bgSurface2,
                border: Border.all(
                  color: context.error.withOpacity(0.25),
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: context.error.withOpacity(0.08),
                    blurRadius: 40,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning icon ring
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: context.error.withOpacity(0.1),
                      border: Border.all(
                        color: context.error.withOpacity(0.3),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('⚠️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'END SESSION?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Body text
                  Text(
                    "You're doing great! Stopping now means\nlosing your current streak progress.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.7,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Progress summary
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildStat(
                          context,
                          value: '$currentRound/$totalRounds',
                          label: 'Rounds',
                          color: context.accentLight,
                        ),
                        _buildStat(
                          context,
                          value: elapsedFormatted,
                          label: 'Done',
                          color: context.prep,
                        ),
                        _buildStat(
                          context,
                          value: remainingFormatted,
                          label: 'Left',
                          color: context.workout,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      // Keep Going
                      Expanded(
                        child: GestureDetector(
                          onTap: onKeepGoing,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              color: context.bgSurface3,
                              border: Border.all(color: context.borderDefault),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'Keep Going 💪',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // End Session
                      Expanded(
                        child: GestureDetector(
                          onTap: onEndSession,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.error,
                                  context.error.withRed(220),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: context.error.withOpacity(0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'End Session',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context,
      {required String value, required String label, required Color color}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: context.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
