import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/congratulation_screen.dart';
import 'package:stop_watch/widgets/confirmation_modal_box.dart';
import 'package:stop_watch/widgets/custom_pageroutes.dart';
import 'package:stop_watch/widgets/workout_progress.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.bgBase,
        appBar: AppBar(
          backgroundColor: context.bgBase,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: context.textMuted,
              size: 30,
            ),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
          title: Text(
            "SweatClock",
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildTimer(context),
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    final home = Provider.of<Home>(context);

    if (!home.isPrepComplete && !home.isRestComplete && !home.isWorkComplete) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(customCircularPageRoute(
          page: const CongratulationScreen(),
        ));
      });
    }

    return Column(
      children: [
        _buildPhaseBar(context, home),
        const SizedBox(height: 10),
        _buildRoundRow(context, home),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWorkoutProgress(context, home),
            ],
          ),
        ),
        _buildNextRow(context, home),
        const SizedBox(height: 16),
        _buildPauseAndResume(context, home),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPhaseBar(BuildContext context, Home home) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PREP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: context.prep)),
              Text("WORKOUT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: context.workout)),
              Text("REST", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: context.rest)),
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
            child: Stack(
              children: [
                Container(
                  width: _calculatePhaseProgress(home) * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [context.prepLight, context.workoutLight],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculatePhaseProgress(Home home) {
    if (home.isPrepComplete) return 0.15;
    if (home.isWorkComplete) return 0.50;
    if (home.isRestComplete) return 0.85;
    return 0.0;
  }

  Widget _buildRoundRow(BuildContext context, Home home) {
    List<Widget> dots = [];
    for (int i = 1; i <= home.totalWorkout; i++) {
      dots.add(Expanded(
        child: Container(
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: i <= home.currentWorkoutStage ? context.accent : context.bgSurface3,
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
            "${home.currentWorkoutStage} / ${home.totalWorkout}",
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

  Widget _buildWorkoutProgress(BuildContext context, Home home) {
    if (home.isPrepComplete) {
      return WorkoutProgress(
        key: const ValueKey('Ready'),
        sec: home.prepMin * 60 + home.prepSec,
        workoutType: 'PREP',
        color: context.prep,
      );
    } else if (home.isRestComplete) {
      return WorkoutProgress(
        key: const ValueKey('Rest'),
        sec: home.restMin * 60 + home.restSec,
        workoutType: 'REST',
        color: context.rest,
      );
    } else if (home.isWorkComplete) {
      return WorkoutProgress(
        key: const ValueKey('Work'),
        sec: home.workoutMin * 60 + home.workoutSec,
        workoutType: 'WORKOUT',
        color: context.workout,
      );
    } else {
      return Text(
        'PREPARE',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: context.textPrimary,
        ),
      );
    }
  }

  Widget _buildNextRow(BuildContext context, Home home) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildNextBox(
              context,
              label: 'Next: ${home.isWorkComplete ? "Rest" : "Workout"}',
              value: home.isWorkComplete
                  ? '${home.restMin}:${home.restSec.toString().padLeft(2, '0')}'
                  : '${home.workoutMin}:${home.workoutSec.toString().padLeft(2, '0')}',
              color: home.isWorkComplete ? context.rest : context.workout,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildNextBox(
              context,
              label: 'Round ${home.currentWorkoutStage + 1}',
              value: '${home.workoutMin}:${home.workoutSec.toString().padLeft(2, '0')}',
              color: context.workout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextBox(BuildContext context, {required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: context.bgSurface,
        border: Border.all(color: context.borderSubtle),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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

  Widget _buildPauseAndResume(BuildContext context, Home home) {
    bool isPaused = home.isWorkoutPaused;
    return GestureDetector(
      onTap: () => home.changeIsWorkoutPaused(!isPaused),
      child: Container(
        width: 60,
        height: 60,
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
          isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
