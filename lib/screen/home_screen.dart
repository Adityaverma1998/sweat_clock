import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/core/constant/app_assets_constant.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/timer_screen.dart';
import 'package:stop_watch/widgets/close_app_modal_box.dart';
import 'package:stop_watch/widgets/custom_pageroutes.dart';
import 'package:stop_watch/widgets/set_time_bottom_sheet.dart';
import 'package:stop_watch/widgets/total_workout_bottom_sheet.dart';

import 'package:stop_watch/screen/settings_screen.dart';

import 'package:stop_watch/core/utils/in_app_update_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    InAppUpdateHelper.checkForPlayStoreUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await closeAppModalBox(context);
      },
      child: Scaffold(
        backgroundColor: context.bgBase,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildGreeting(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildConfigCard(
                        context,
                        icon: '🔁',
                        iconBg: context.accentBg,
                        borderColor: context.accentLight,
                        title: 'Total Sets',
                        value: '${Provider.of<Home>(context).totalWorkout} Rounds',
                        valueColor: context.accent,
                        onTap: () => totalWorkoutBottomSheet(context),
                      ),
                      _buildConfigCard(
                        context,
                        icon: '⏳',
                        iconBg: context.prepBg,
                        borderColor: context.prepLight,
                        title: 'Prep Time',
                        value: _formatTime(Provider.of<Home>(context).prepMin, Provider.of<Home>(context).prepSec),
                        valueColor: context.prep,
                        onTap: () => showTimePickerBottomSheet(context, 'preparation'),
                      ),
                      _buildConfigCard(
                        context,
                        icon: '🔥',
                        iconBg: context.workoutBg,
                        borderColor: context.workoutLight,
                        title: 'Workout Time',
                        value: _formatTime(Provider.of<Home>(context).workoutMin, Provider.of<Home>(context).workoutSec),
                        valueColor: context.workout,
                        onTap: () => showTimePickerBottomSheet(context, 'workout'),
                      ),
                      _buildConfigCard(
                        context,
                        icon: '🧘',
                        iconBg: context.restBg,
                        borderColor: context.restLight,
                        title: 'Rest Time',
                        value: _formatTime(Provider.of<Home>(context).restMin, Provider.of<Home>(context).restSec),
                        valueColor: context.rest,
                        onTap: () => showTimePickerBottomSheet(context, 'rest'),
                      ),
                      const SizedBox(height: 16),
                      _buildTimeline(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int min, int sec) {
    return '${min.toString()}:${sec.toString().padLeft(2, '0')}';
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SweatClock",
            style: TextStyle(
              fontSize: 30,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              color: context.accent,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: context.shadowColor.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text('⚙️', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: context.textMuted,
              letterSpacing: 0.3,
            ),
            children: [
              const TextSpan(text: "Ready to crush it? "),
              TextSpan(
                text: "Let's go! 🔥",
                style: TextStyle(
                  color: context.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigCard(
    BuildContext context, {
    required String icon,
    required Color iconBg,
    required Color borderColor,
    required String title,
    required String value,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: context.bgSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 3,
                color: borderColor,
              ),
              const SizedBox(width: 12),
              Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: context.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: valueColor,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: context.bgSurface2,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: context.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SESSION TIMELINE",
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: context.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Row(
              children: [
                Expanded(flex: 1, child: Container(height: 5, color: context.prepLight, margin: const EdgeInsets.only(right: 2))),
                Expanded(flex: 2, child: Container(height: 5, color: context.workoutLight, margin: const EdgeInsets.only(right: 2))),
                Expanded(flex: 1, child: Container(height: 5, color: context.restLight, margin: const EdgeInsets.only(right: 2))),
                Expanded(flex: 2, child: Container(height: 5, color: context.workoutLight, margin: const EdgeInsets.only(right: 2))),
                Expanded(flex: 1, child: Container(height: 5, color: context.restLight, margin: const EdgeInsets.only(right: 2))),
                Expanded(flex: 2, child: Container(height: 5, color: context.workoutLight, margin: const EdgeInsets.only(right: 2))),
                Expanded(flex: 1, child: Container(height: 5, color: context.restLight)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimelineLegend(context, 'Prep', context.prepLight),
              _buildTimelineLegend(context, 'Work', context.workoutLight),
              _buildTimelineLegend(context, 'Rest', context.restLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineLegend(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            color: context.textMuted,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final home = Provider.of<Home>(context);
    final totalSec = home.totalSec;
    final min = totalSec ~/ 60;
    final sec = totalSec % 60;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12, color: context.textMuted),
              children: [
                const TextSpan(text: "Total Duration: "),
                TextSpan(
                  text: "${min}m ${sec}s",
                  style: TextStyle(
                    color: context.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              home.changeIsPrepComplete(true);
              Navigator.push(
                context,
                customCircularPageRoute(
                  page: const TimerScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.accent, context.accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.accent.withOpacity(0.4),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Start Workout',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
