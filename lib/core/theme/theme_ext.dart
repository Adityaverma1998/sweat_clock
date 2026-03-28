// theme_ext.dart
import 'package:flutter/material.dart';
import 'package:stop_watch/core/theme/dark/dark_app_theme.dart';
import 'package:stop_watch/core/theme/light/light_app_theme.dart';

extension AppColorsX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Backgrounds
  Color get bgBase => isDark ? DarkThemeColors.bgBase : LightThemeColors.bgBase;
  Color get bgSurface =>
      isDark ? DarkThemeColors.bgSurface : LightThemeColors.bgSurface;
  Color get bgSurface2 =>
      isDark ? DarkThemeColors.bgSurface2 : LightThemeColors.bgSurface2;
  Color get bgSurface3 =>
      isDark ? DarkThemeColors.bgSurface3 : LightThemeColors.bgSurface3;

  // Text
  Color get textPrimary =>
      isDark ? DarkThemeColors.textPrimary : LightThemeColors.textPrimary;
  Color get textSecondary =>
      isDark ? DarkThemeColors.textSecondary : LightThemeColors.textSecondary;
  Color get textMuted =>
      isDark ? DarkThemeColors.textMuted : LightThemeColors.textMuted;
  Color get textDisabled =>
      isDark ? DarkThemeColors.textDisabled : LightThemeColors.textDisabled;

  // Borders
  Color get borderSubtle =>
      isDark ? DarkThemeColors.borderSubtle : LightThemeColors.borderSubtle;
  Color get borderDefault =>
      isDark ? DarkThemeColors.borderDefault : LightThemeColors.borderDefault;
  Color get borderStrong =>
      isDark ? DarkThemeColors.borderStrong : LightThemeColors.borderStrong;

  // Phases
  Color get prep => isDark ? DarkThemeColors.prep : LightThemeColors.prep;
  Color get prepLight =>
      isDark ? DarkThemeColors.prepLight : LightThemeColors.prepLight;
  Color get prepBg => isDark ? DarkThemeColors.prepBg : LightThemeColors.prepBg;
  Color get prepBorder =>
      isDark ? DarkThemeColors.prepBorder : LightThemeColors.prepBorder;

  Color get workout =>
      isDark ? DarkThemeColors.workout : LightThemeColors.workout;
  Color get workoutLight =>
      isDark ? DarkThemeColors.workoutLight : LightThemeColors.workoutLight;
  Color get workoutBg =>
      isDark ? DarkThemeColors.workoutBg : LightThemeColors.workoutBg;
  Color get workoutBorder =>
      isDark ? DarkThemeColors.workoutBorder : LightThemeColors.workoutBorder;

  Color get rest => isDark ? DarkThemeColors.rest : LightThemeColors.rest;
  Color get restLight =>
      isDark ? DarkThemeColors.restLight : LightThemeColors.restLight;
  Color get restBg => isDark ? DarkThemeColors.restBg : LightThemeColors.restBg;
  Color get restBorder =>
      isDark ? DarkThemeColors.restBorder : LightThemeColors.restBorder;

  // Accent
  Color get accent => isDark ? DarkThemeColors.accent : LightThemeColors.accent;
  Color get accentLight =>
      isDark ? DarkThemeColors.accentLight : LightThemeColors.accentLight;
  Color get accentSubtle =>
      isDark ? DarkThemeColors.accentSubtle : LightThemeColors.accentSubtle;
  Color get accentBg =>
      isDark ? DarkThemeColors.accentBg : LightThemeColors.accentBg;
  Color get accentBorder =>
      isDark ? DarkThemeColors.accentBorder : LightThemeColors.accentBorder;

  // Status
  Color get success =>
      isDark ? DarkThemeColors.success : LightThemeColors.success;
  Color get successLight =>
      isDark ? DarkThemeColors.successLight : LightThemeColors.successLight;
  Color get successBg =>
      isDark ? DarkThemeColors.successBg : LightThemeColors.successBg;

  Color get warning =>
      isDark ? DarkThemeColors.warning : LightThemeColors.warning;
  Color get warningBg =>
      isDark ? DarkThemeColors.warningBg : LightThemeColors.warningBg;

  Color get error => isDark ? DarkThemeColors.error : LightThemeColors.error;
  Color get errorLight =>
      isDark ? DarkThemeColors.errorLight : LightThemeColors.errorLight;
  Color get errorBg =>
      isDark ? DarkThemeColors.errorBg : LightThemeColors.errorBg;

  // Misc
  Color get gold => isDark ? DarkThemeColors.gold : LightThemeColors.gold;
  Color get shadowColor =>
      isDark ? DarkThemeColors.shadowColor : LightThemeColors.shadowColor;
  Color get fabBackground =>
      isDark ? DarkThemeColors.fabBackground : LightThemeColors.fabBackground;
  Color get fabForeground =>
      isDark ? DarkThemeColors.fabForeground : LightThemeColors.fabForeground;

  // Timeline
  Color get timelineTrack =>
      isDark ? DarkThemeColors.timelineTrack : LightThemeColors.timelineTrack;
  Color get timelinePrep =>
      isDark ? DarkThemeColors.timelinePrep : LightThemeColors.timelinePrep;
  Color get timelineWorkout => isDark
      ? DarkThemeColors.timelineWorkout
      : LightThemeColors.timelineWorkout;
  Color get timelineRest =>
      isDark ? DarkThemeColors.timelineRest : LightThemeColors.timelineRest;

  // Ring gradients
  Color get ringTrack =>
      isDark ? DarkThemeColors.ringTrack : LightThemeColors.ringTrack;
  Color get ringPrepGradStart => isDark
      ? DarkThemeColors.ringPrepGradStart
      : LightThemeColors.ringPrepGradStart;
  Color get ringPrepGradEnd => isDark
      ? DarkThemeColors.ringPrepGradEnd
      : LightThemeColors.ringPrepGradEnd;
  Color get ringWorkoutGradStart => isDark
      ? DarkThemeColors.ringWorkoutGradStart
      : LightThemeColors.ringWorkoutGradStart;
  Color get ringWorkoutGradEnd => isDark
      ? DarkThemeColors.ringWorkoutGradEnd
      : LightThemeColors.ringWorkoutGradEnd;
  Color get ringRestGradStart => isDark
      ? DarkThemeColors.ringRestGradStart
      : LightThemeColors.ringRestGradStart;
  Color get ringRestGradEnd => isDark
      ? DarkThemeColors.ringRestGradEnd
      : LightThemeColors.ringRestGradEnd;

  // Coffee tiers
  Color get coffeeTierBg =>
      isDark ? DarkThemeColors.coffeeTierBg : LightThemeColors.coffeeTierBg;
  Color get coffeeTierBgBest => isDark
      ? DarkThemeColors.coffeeTierBgBest
      : LightThemeColors.coffeeTierBgBest;
  Color get coffeeTierBorder => isDark
      ? DarkThemeColors.coffeeTierBorder
      : LightThemeColors.coffeeTierBorder;
  Color get coffeeTierBorderBest => isDark
      ? DarkThemeColors.coffeeTierBorderBest
      : LightThemeColors.coffeeTierBorderBest;

  // Round dots
  Color get roundDotActive =>
      isDark ? DarkThemeColors.roundDotActive : LightThemeColors.roundDotActive;
  Color get roundDotDone =>
      isDark ? DarkThemeColors.roundDotDone : LightThemeColors.roundDotDone;
  Color get roundDotIdle =>
      isDark ? DarkThemeColors.roundDotIdle : LightThemeColors.roundDotIdle;
}
