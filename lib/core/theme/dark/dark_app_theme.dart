import 'package:flutter/material.dart';
import 'package:stop_watch/core/theme/color_palettes.dart';

class DarkThemeColors {
  DarkThemeColors._();

  // ─── Backgrounds ──────────────────────────────────────────
  static const Color bgBase = AppColors.neutral900;
  static const Color bgSurface = AppColors.neutral750;
  static const Color bgSurface2 = AppColors.neutral650;
  static const Color bgSurface3 = AppColors.neutral600;
  static const Color bgOverlay = AppColors.darkScrim;

  // ─── Borders ──────────────────────────────────────────────
  static const Color borderSubtle = AppColors.white_07;
  static const Color borderDefault = AppColors.white_13;
  static const Color borderStrong = AppColors.purple400_30;

  // ─── Text ─────────────────────────────────────────────────
  static const Color textPrimary = AppColors.white;
  static const Color textSecondary = AppColors.white_80;
  static const Color textMuted = AppColors.neutral400;
  static const Color textDisabled = Color(0x604A466A);

  // ─── Prep (Amber) ─────────────────────────────────────────
  static const Color prep = AppColors.amber500;
  static const Color prepLight = AppColors.amber300;
  static const Color prepBg = AppColors.amber500_12;
  static const Color prepBorder = AppColors.amber500_30;

  // ─── Workout (Red) ────────────────────────────────────────
  static const Color workout = AppColors.red500;
  static const Color workoutLight = AppColors.red400;
  static const Color workoutBg = AppColors.red500_12;
  static const Color workoutBorder = AppColors.red500_30;

  // ─── Rest (Blue) ──────────────────────────────────────────
  static const Color rest = AppColors.blue500;
  static const Color restLight = AppColors.blue400;
  static const Color restBg = AppColors.blue500_12;
  static const Color restBorder = AppColors.blue500_30;

  // ─── Accent (Purple) ──────────────────────────────────────
  static const Color accent = AppColors.purple600;
  static const Color accentLight = AppColors.purple400;
  static const Color accentSubtle = AppColors.purple300;
  static const Color accentBg = AppColors.purple600_08;
  static const Color accentBorder = AppColors.purple600_20;

  // ─── Success (Green) ──────────────────────────────────────
  static const Color success = AppColors.green600;
  static const Color successLight = AppColors.green500;
  static const Color successBg = AppColors.green500_12;

  // ─── Warning ──────────────────────────────────────────────
  static const Color warning = AppColors.amber500;
  static const Color warningBg = AppColors.amber500_12;

  // ─── Error ────────────────────────────────────────────────
  static const Color error = AppColors.red600;
  static const Color errorLight = AppColors.red500;
  static const Color errorBg = AppColors.red600_12;

  // ─── Gold ─────────────────────────────────────────────────
  static const Color gold = AppColors.amber400;

  // ─── Ring ─────────────────────────────────────────────────
  static const Color ringTrack = AppColors.white_05;
  static const Color ringPrepGradStart = AppColors.amber500;
  static const Color ringPrepGradEnd = AppColors.amber300;
  static const Color ringWorkoutGradStart = AppColors.amber500;
  static const Color ringWorkoutGradEnd = AppColors.red700;
  static const Color ringRestGradStart = AppColors.blue400;
  static const Color ringRestGradEnd = AppColors.blue500;

  // ─── FAB ──────────────────────────────────────────────────
  static const Color fabBackground = AppColors.purple600;
  static const Color fabForeground = AppColors.white;

  // ─── Timeline ─────────────────────────────────────────────
  static const Color timelineTrack = AppColors.neutral650;
  static const Color timelinePrep = AppColors.amber500;
  static const Color timelineWorkout = AppColors.red500;
  static const Color timelineRest = AppColors.blue500;

  // ─── Toggle ───────────────────────────────────────────────
  static const Color toggleActiveTrack = AppColors.purple600;
  static const Color toggleInactiveTrack = AppColors.white_10;
  static const Color toggleThumb = AppColors.white;

  // ─── Coffee Tiers ─────────────────────────────────────────
  static const Color coffeeTierBg = AppColors.neutral750;
  static const Color coffeeTierBgBest = AppColors.purple600_20;
  static const Color coffeeTierBorder = AppColors.white_07;
  static const Color coffeeTierBorderBest = AppColors.purple400_50;

  // ─── Round Dots ───────────────────────────────────────────
  static const Color roundDotActive = AppColors.purple400;
  static const Color roundDotDone = AppColors.purple400_30;
  static const Color roundDotIdle = AppColors.neutral650;

  // ─── Shadow ───────────────────────────────────────────────
  static const Color shadowColor = AppColors.black;
}
