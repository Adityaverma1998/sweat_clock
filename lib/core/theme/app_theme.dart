import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch/core/theme/dark/dark_app_theme.dart';
import 'package:stop_watch/core/theme/light/light_app_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(false);
  static ThemeData get dark => _build(true);

  static ThemeData _build(bool isDark) {
    // Pick color class based on theme
    final bg = isDark ? DarkThemeColors.bgBase : LightThemeColors.bgBase;
    final surface =
        isDark ? DarkThemeColors.bgSurface : LightThemeColors.bgSurface;
    final surface2 =
        isDark ? DarkThemeColors.bgSurface2 : LightThemeColors.bgSurface2;
    final surface3 =
        isDark ? DarkThemeColors.bgSurface3 : LightThemeColors.bgSurface3;
    final overlay =
        isDark ? DarkThemeColors.bgOverlay : LightThemeColors.bgOverlay;

    final bSubtle =
        isDark ? DarkThemeColors.borderSubtle : LightThemeColors.borderSubtle;
    final bDefault =
        isDark ? DarkThemeColors.borderDefault : LightThemeColors.borderDefault;
    final bStrong =
        isDark ? DarkThemeColors.borderStrong : LightThemeColors.borderStrong;

    final tPrimary =
        isDark ? DarkThemeColors.textPrimary : LightThemeColors.textPrimary;
    final tSecondary =
        isDark ? DarkThemeColors.textSecondary : LightThemeColors.textSecondary;
    final tMuted =
        isDark ? DarkThemeColors.textMuted : LightThemeColors.textMuted;
    final tDisabled =
        isDark ? DarkThemeColors.textDisabled : LightThemeColors.textDisabled;

    final prep = isDark ? DarkThemeColors.prep : LightThemeColors.prep;
    final prepLight =
        isDark ? DarkThemeColors.prepLight : LightThemeColors.prepLight;
    final prepBg = isDark ? DarkThemeColors.prepBg : LightThemeColors.prepBg;
    final prepBorder =
        isDark ? DarkThemeColors.prepBorder : LightThemeColors.prepBorder;

    final workout = isDark ? DarkThemeColors.workout : LightThemeColors.workout;
    final workoutLight =
        isDark ? DarkThemeColors.workoutLight : LightThemeColors.workoutLight;
    final workoutBg =
        isDark ? DarkThemeColors.workoutBg : LightThemeColors.workoutBg;
    final workoutBorder =
        isDark ? DarkThemeColors.workoutBorder : LightThemeColors.workoutBorder;

    final rest = isDark ? DarkThemeColors.rest : LightThemeColors.rest;
    final restLight =
        isDark ? DarkThemeColors.restLight : LightThemeColors.restLight;
    final restBg = isDark ? DarkThemeColors.restBg : LightThemeColors.restBg;
    final restBorder =
        isDark ? DarkThemeColors.restBorder : LightThemeColors.restBorder;

    final accent = isDark ? DarkThemeColors.accent : LightThemeColors.accent;
    final accentLight =
        isDark ? DarkThemeColors.accentLight : LightThemeColors.accentLight;
    final accentSubtle =
        isDark ? DarkThemeColors.accentSubtle : LightThemeColors.accentSubtle;
    final accentBg =
        isDark ? DarkThemeColors.accentBg : LightThemeColors.accentBg;
    final accentBorder =
        isDark ? DarkThemeColors.accentBorder : LightThemeColors.accentBorder;

    final success = isDark ? DarkThemeColors.success : LightThemeColors.success;
    final successLight =
        isDark ? DarkThemeColors.successLight : LightThemeColors.successLight;
    final successBg =
        isDark ? DarkThemeColors.successBg : LightThemeColors.successBg;

    final warning = isDark ? DarkThemeColors.warning : LightThemeColors.warning;
    final warningBg =
        isDark ? DarkThemeColors.warningBg : LightThemeColors.warningBg;

    final error = isDark ? DarkThemeColors.error : LightThemeColors.error;
    final errorLight =
        isDark ? DarkThemeColors.errorLight : LightThemeColors.errorLight;
    final errorBg = isDark ? DarkThemeColors.errorBg : LightThemeColors.errorBg;

    final gold = isDark ? DarkThemeColors.gold : LightThemeColors.gold;
    final shadow =
        isDark ? DarkThemeColors.shadowColor : LightThemeColors.shadowColor;
    final fabBg =
        isDark ? DarkThemeColors.fabBackground : LightThemeColors.fabBackground;
    final fabFg =
        isDark ? DarkThemeColors.fabForeground : LightThemeColors.fabForeground;

    final togActive = isDark
        ? DarkThemeColors.toggleActiveTrack
        : LightThemeColors.toggleActiveTrack;
    final togInactive = isDark
        ? DarkThemeColors.toggleInactiveTrack
        : LightThemeColors.toggleInactiveTrack;
    final togThumb =
        isDark ? DarkThemeColors.toggleThumb : LightThemeColors.toggleThumb;

    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,

      // ── Color scheme ────────────────────────────────────────
      colorScheme: ColorScheme(
        brightness: brightness,
        // Primary = accent purple
        primary: accent,
        onPrimary: fabFg,
        primaryContainer: accentBg,
        onPrimaryContainer: accentSubtle,
        // Secondary = lighter purple
        secondary: accentLight,
        onSecondary: fabFg,
        secondaryContainer: accentBg,
        onSecondaryContainer: accentLight,
        // Tertiary = prep amber
        tertiary: prep,
        onTertiary: fabFg,
        tertiaryContainer: prepBg,
        onTertiaryContainer: prepLight,
        // Error = red
        error: error,
        onError: fabFg,
        errorContainer: errorBg,
        onErrorContainer: errorLight,
        // Surface
        surface: surface,
        onSurface: tPrimary,
        onSurfaceVariant: tMuted,
        // Outline
        outline: bDefault,
        outlineVariant: bSubtle,
        // Shadow / scrim
        shadow: shadow,
        scrim: overlay,
        // Inverse
        inverseSurface: isDark ? fabFg : tPrimary,
        onInverseSurface: isDark ? tPrimary : fabFg,
        inversePrimary: accentSubtle,
        // Surface containers
        surfaceContainerHighest: surface2,
        surfaceContainerHigh: surface2,
        surfaceContainer: surface,
        surfaceContainerLow: surface,
        surfaceContainerLowest: bg,
      ),

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: tPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: bg,
        ),
        titleTextStyle: TextStyle(
          color: tPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: tPrimary, size: 22),
      ),

      // ── Card ────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: bSubtle, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      ),

      // ── ElevatedButton ──────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: fabFg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),

      // ── OutlinedButton ──────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tSecondary,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(color: bDefault, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // ── TextButton ──────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // ── FilledButton ────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: fabFg,
          surfaceTintColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: fabBg,
        foregroundColor: fabFg,
        elevation: 8,
        shape: const CircleBorder(),
      ),

      // ── IconButton ──────────────────────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: tMuted,
          backgroundColor: surface2,
          minimumSize: const Size(32, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: bSubtle),
          ),
        ),
      ),

      // ── Switch ──────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(togThumb),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? togActive : togInactive),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Checkbox ────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : Colors.transparent),
        checkColor: WidgetStateProperty.all(fabFg),
        side: BorderSide(color: bDefault, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),

      // ── Radio ───────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? accent : tMuted),
      ),

      // ── Slider ──────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: accent,
        inactiveTrackColor: surface3,
        thumbColor: accent,
        overlayColor: accentBg,
        valueIndicatorColor: accent,
        valueIndicatorTextStyle:
            TextStyle(color: fabFg, fontSize: 13, fontWeight: FontWeight.w600),
        trackHeight: 4,
        // thumbRadius:              10,
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),

      // ── Progress ────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: surface3,
        circularTrackColor: surface3,
        linearMinHeight: 4,
      ),

      // ── ListTile ────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: surface,
        textColor: tPrimary,
        iconColor: tMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      // ── Divider ─────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: bSubtle,
        thickness: 1,
        space: 0,
      ),

      // ── Dialog ──────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surface2,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: bDefault),
        ),
        titleTextStyle: TextStyle(
          color: tPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(
          color: tMuted,
          fontSize: 13,
          height: 1.6,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),

      // ── BottomSheet ─────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface2,
        modalBackgroundColor: surface2,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        dragHandleColor: bDefault,
        dragHandleSize: const Size(40, 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      // ── SnackBar ────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isDark ? const Color(0xFF2D2845) : const Color(0xFF1A1535),
        contentTextStyle: TextStyle(
          color: fabFg,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: accentSubtle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // ── Chip ────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: accentBg,
        disabledColor: surface3,
        surfaceTintColor: Colors.transparent,
        labelStyle: TextStyle(
          color: tSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: bSubtle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 0,
        pressElevation: 0,
        iconTheme: IconThemeData(color: tMuted, size: 16),
      ),

      // ── Input ───────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: tMuted, fontSize: 14),
        labelStyle: TextStyle(color: tMuted, fontSize: 14),
        floatingLabelStyle: TextStyle(color: accent, fontSize: 12),
        errorStyle: TextStyle(color: error, fontSize: 12),
        helperStyle: TextStyle(color: tMuted, fontSize: 12),
        prefixIconColor: tMuted,
        suffixIconColor: tMuted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: bSubtle, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: bSubtle, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: bSubtle, width: 1),
        ),
      ),

      // ── NavigationBar ───────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accentBg,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          final sel = s.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: sel ? accent : tMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((s) {
          final sel = s.contains(WidgetState.selected);
          return IconThemeData(color: sel ? accent : tMuted, size: 22);
        }),
      ),

      // ── TabBar ──────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: accent,
        unselectedLabelColor: tMuted,
        indicatorColor: accent,
        dividerColor: bSubtle,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Drawer ──────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
      ),

      // ── PopupMenu ───────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: surface2,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: bDefault),
        ),
        textStyle: TextStyle(
          color: tPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ── Tooltip ─────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surface3,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: bSubtle),
        ),
        textStyle: TextStyle(
          color: tPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        waitDuration: const Duration(milliseconds: 600),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),

      // ── Badge ───────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: error,
        textColor: fabFg,
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        smallSize: 8,
        largeSize: 20,
      ),

      // ── Text ────────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w900,
            color: tPrimary,
            height: 1.1,
            letterSpacing: -0.25),
        displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w800,
            color: tPrimary,
            height: 1.15),
        displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: tPrimary,
            height: 1.2),
        headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: tPrimary,
            height: 1.2),
        headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: tPrimary,
            height: 1.25),
        headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: tPrimary,
            height: 1.3),
        titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: tPrimary,
            height: 1.3),
        titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: tPrimary,
            height: 1.4,
            letterSpacing: 0.15),
        titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: tSecondary,
            height: 1.4,
            letterSpacing: 0.1),
        bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: tSecondary,
            height: 1.6),
        bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: tSecondary,
            height: 1.6),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: tMuted,
            height: 1.6),
        labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: tPrimary,
            letterSpacing: 0.1),
        labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: tMuted,
            letterSpacing: 0.5),
        labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: tMuted,
            letterSpacing: 1.5),
      ),

      // ── Icons ───────────────────────────────────────────────
      iconTheme: IconThemeData(color: tMuted, size: 22),
      primaryIconTheme: IconThemeData(color: accent, size: 22),

      // ── Page transitions ────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
