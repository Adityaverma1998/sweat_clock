import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Purple ───────────────────────────────────────────────
  static const Color purple900 = Color(0xFF3B0764);
  static const Color purple800 = Color(0xFF5B21B6);
  static const Color purple700 = Color(0xFF6D28D9);
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple400 = Color(0xFFA855F7);
  static const Color purple300 = Color(0xFFC084FC);
  static const Color purple200 = Color(0xFFDDD6FE);
  static const Color purple100 = Color(0xFFEDE9FE);
  static const Color purple50 = Color(0xFFF5F3FF);

  // ─── Amber / Prep ─────────────────────────────────────────
  static const Color amber700 = Color(0xFFB45309);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber300 = Color(0xFFFCD34D);
  static const Color amber200 = Color(0xFFFDE68A);
  static const Color amber100 = Color(0xFFFEF3C7);

  // ─── Red / Workout ────────────────────────────────────────
  static const Color red900 = Color(0xFF7F1D1D);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red700 = Color(0xFFB91C1C);
  static const Color red600 = Color(0xFFDC2626);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red400 = Color(0xFFF87171);
  static const Color red300 = Color(0xFFFCA5A5);
  static const Color red100 = Color(0xFFFEE2E2);

  // ─── Blue / Rest ──────────────────────────────────────────
  static const Color blue900 = Color(0xFF1E3A8A);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue400 = Color(0xFF60A5FA);
  static const Color blue300 = Color(0xFF93C5FD);
  static const Color blue100 = Color(0xFFDBEAFE);

  // ─── Green / Success ──────────────────────────────────────
  static const Color green800 = Color(0xFF14532D);
  static const Color green700 = Color(0xFF15803D);
  static const Color green600 = Color(0xFF16A34A);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green400 = Color(0xFF4ADE80);
  static const Color green300 = Color(0xFF86EFAC);
  static const Color green100 = Color(0xFFDCFCE7);

  // ─── Pink ─────────────────────────────────────────────────
  static const Color pink600 = Color(0xFFDB2777);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink400 = Color(0xFFF472B6);

  // ─── Dark Neutrals ────────────────────────────────────────
  static const Color neutral950 = Color(0xFF060609);
  static const Color neutral900 = Color(0xFF0D0B16);
  static const Color neutral850 = Color(0xFF0E0C17);
  static const Color neutral800 = Color(0xFF121020);
  static const Color neutral750 = Color(0xFF161324);
  static const Color neutral700 = Color(0xFF1A1733);
  static const Color neutral650 = Color(0xFF1E1A32);
  static const Color neutral600 = Color(0xFF252040);
  static const Color neutral550 = Color(0xFF2D2845);
  static const Color neutral500 = Color(0xFF3D3660);
  static const Color neutral400 = Color(0xFF6B677F);
  static const Color neutral300 = Color(0xFF9491AA);

  // ─── Light Neutrals ───────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFDF4FF);
  static const Color grey100 = Color(0xFFF5F3FF);
  static const Color grey200 = Color(0xFFEDE9FE);
  static const Color grey300 = Color(0xFFE8E3F8);
  static const Color grey400 = Color(0xFFD4D0E8);
  static const Color grey500 = Color(0xFF9B97B0);
  static const Color grey600 = Color(0xFF6E6A85);
  static const Color grey700 = Color(0xFF4A4660);
  static const Color grey800 = Color(0xFF2D2A40);
  static const Color grey900 = Color(0xFF1A1535);
  static const Color black = Color(0xFF000000);

  // ─── Transparent tints (used in dark_theme_colors.dart) ───
  // Purple tints
  static const Color purple600_05 = Color(0x0D7C3AED);
  static const Color purple600_06 = Color(0x0F7C3AED);
  static const Color purple600_08 = Color(0x147C3AED);
  static const Color purple600_10 = Color(0x1A7C3AED);
  static const Color purple600_12 = Color(0x1F7C3AED);
  static const Color purple600_15 = Color(0x267C3AED);
  static const Color purple600_20 = Color(0x337C3AED);
  static const Color purple600_25 = Color(0x407C3AED);
  static const Color purple600_35 = Color(0x597C3AED);
  static const Color purple600_40 = Color(0x667C3AED);
  static const Color purple400_30 = Color(0x4DA855F7);
  static const Color purple400_50 = Color(0x80A855F7);

  // White tints (dark theme borders / overlays)
  static const Color white_05 = Color(0x0DFFFFFF);
  static const Color white_07 = Color(0x12FFFFFF);
  static const Color white_10 = Color(0x1AFFFFFF);
  static const Color white_13 = Color(0x20FFFFFF);
  static const Color white_25 = Color(0x40FFFFFF);
  static const Color white_80 = Color(0xCCFFFFFF);

  // Black tints (light theme)
  static const Color black_10 = Color(0x1A000000);

  // Dark overlay scrim
  static const Color darkScrim = Color(0xCC060609);
  static const Color lightScrim = Color(0xD0EDE9FE);

  // Amber tints
  static const Color amber500_10 = Color(0x1AF59E0B);
  static const Color amber500_12 = Color(0x1FF59E0B);
  static const Color amber500_30 = Color(0x4DF5A623);
  static const Color amber600_10 = Color(0x1AD97706);
  static const Color amber600_25 = Color(0x40F59E0B);

  // Red tints
  static const Color red500_12 = Color(0x1FEF4444);
  static const Color red500_30 = Color(0x4DEF4444);
  static const Color red600_10 = Color(0x1ADC2626);
  static const Color red600_12 = Color(0x1FDC2626);
  static const Color red700_10 = Color(0x1AB91C1C);

  // Blue tints
  static const Color blue500_12 = Color(0x1F3B82F6);
  static const Color blue500_30 = Color(0x4D3B82F6);
  static const Color blue600_10 = Color(0x1A2563EB);
  static const Color blue600_25 = Color(0x403B82F6);
  static const Color purple600_ring = Color(0x147C3AED);

  // Green tints
  static const Color green500_12 = Color(0x1F22C55E);
  static const Color green600_08 = Color(0x1516A34A);
  static const Color green600_10 = Color(0x1516A34A);
}
