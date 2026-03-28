import 'package:flutter/material.dart';
import 'package:stop_watch/core/theme/color_palettes.dart';

class LightThemeColors {
  LightThemeColors._();

  // ─── Backgrounds ──────────────────────────────────────────
  static const Color bgBase = AppColors.grey100;
  static const Color bgSurface = AppColors.white;
  static const Color bgSurface2 = AppColors.grey200;
  static const Color bgSurface3 = AppColors.grey300;
  static const Color bgOverlay = AppColors.lightScrim;

  // ─── Borders ──────────────────────────────────────────────
  static const Color borderSubtle = AppColors.purple600_10;
  static const Color borderDefault = AppColors.purple600_20;
  static const Color borderStrong = AppColors.purple600_40;

  // ─── Text ─────────────────────────────────────────────────
  static const Color textPrimary = AppColors.grey900;
  static const Color textSecondary = AppColors.grey700;
  static const Color textMuted = AppColors.grey600;
  static const Color textDisabled = AppColors.grey500;

  // ─── Prep (Amber — deeper on white) ───────────────────────
  static const Color prep = AppColors.amber600;
  static const Color prepLight = AppColors.amber500;
  static const Color prepBg = AppColors.amber600_10;
  static const Color prepBorder = AppColors.amber600_25;

  // ─── Workout (Red — deeper on white) ──────────────────────
  static const Color workout = AppColors.red600;
  static const Color workoutLight = AppColors.red500;
  static const Color workoutBg = AppColors.red600_10;
  static const Color workoutBorder = AppColors.red600_10;

  // ─── Rest (Blue — deeper on white) ────────────────────────
  static const Color rest = AppColors.blue600;
  static const Color restLight = AppColors.blue500;
  static const Color restBg = AppColors.blue600_10;
  static const Color restBorder = AppColors.blue600_25;

  // ─── Accent (Purple — same brand) ─────────────────────────
  static const Color accent = AppColors.purple600;
  static const Color accentLight = AppColors.purple500;
  static const Color accentSubtle = AppColors.purple400;
  static const Color accentBg = AppColors.purple600_06;
  static const Color accentBorder = AppColors.purple600_15;

  // ─── Success (Green — deeper on white) ────────────────────
  static const Color success = AppColors.green700;
  static const Color successLight = AppColors.green600;
  static const Color successBg = AppColors.green600_08;

  // ─── Warning ──────────────────────────────────────────────
  static const Color warning = AppColors.amber600;
  static const Color warningBg = AppColors.amber600_10;

  // ─── Error ────────────────────────────────────────────────
  static const Color error = AppColors.red700;
  static const Color errorLight = AppColors.red600;
  static const Color errorBg = AppColors.red700_10;

  // ─── Gold ─────────────────────────────────────────────────
  static const Color gold = AppColors.amber600;

  // ─── Ring ─────────────────────────────────────────────────
  static const Color ringTrack = AppColors.purple600_ring;
  static const Color ringPrepGradStart = AppColors.amber500;
  static const Color ringPrepGradEnd = AppColors.amber600;
  static const Color ringWorkoutGradStart = AppColors.amber500;
  static const Color ringWorkoutGradEnd = AppColors.red700;
  static const Color ringRestGradStart = AppColors.blue500;
  static const Color ringRestGradEnd = AppColors.blue700;

  // ─── FAB ──────────────────────────────────────────────────
  static const Color fabBackground = AppColors.purple600;
  static const Color fabForeground = AppColors.white;

  // ─── Timeline ─────────────────────────────────────────────
  static const Color timelineTrack = AppColors.grey300;
  static const Color timelinePrep = AppColors.amber500;
  static const Color timelineWorkout = AppColors.red500;
  static const Color timelineRest = AppColors.blue500;

  // ─── Toggle ───────────────────────────────────────────────
  static const Color toggleActiveTrack = AppColors.purple600;
  static const Color toggleInactiveTrack = AppColors.black_10;
  static const Color toggleThumb = AppColors.white;

  // ─── Coffee Tiers ─────────────────────────────────────────
  static const Color coffeeTierBg = AppColors.white;
  static const Color coffeeTierBgBest = AppColors.purple600_06;
  static const Color coffeeTierBorder = AppColors.purple600_10;
  static const Color coffeeTierBorderBest = AppColors.purple600_35;

  // ─── Round Dots ───────────────────────────────────────────
  static const Color roundDotActive = AppColors.purple600;
  static const Color roundDotDone = AppColors.purple600_25;
  static const Color roundDotIdle = AppColors.grey300;

  // ─── Shadow ───────────────────────────────────────────────
  static const Color shadowColor = AppColors.purple600;
}
