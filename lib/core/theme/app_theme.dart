import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static const fontFamily = 'Schibsted Grotesk';

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: Colors.white,
        surface: Colors.white,
        subtle: AppColors.mist,
        line: AppColors.line,
        ink: AppColors.ink,
        muted: AppColors.inkMuted,
        link: AppColors.raspberryText,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColors.nightBackground,
        surface: AppColors.nightBackground,
        subtle: AppColors.nightSurface,
        line: AppColors.nightLine,
        ink: AppColors.nightInk,
        muted: AppColors.nightInkMuted,
        link: const Color(0xFFFF8FB1),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color subtle,
    required Color line,
    required Color ink,
    required Color muted,
    required Color link,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.raspberry,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.raspberry,
      onPrimary: Colors.white,
      secondary: ink,
      onSecondary: background,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: muted,
      surfaceContainerLowest: background,
      surfaceContainerLow: subtle,
      surfaceContainer: subtle,
      surfaceContainerHigh: subtle,
      surfaceContainerHighest: subtle,
      outline: line,
      outlineVariant: line,
      tertiary: link,
      error: const Color(0xFFB42318),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: background,
    );

    final text = base.textTheme.apply(bodyColor: ink, displayColor: ink);

    return base.copyWith(
      textTheme: text.copyWith(
        headlineLarge: text.headlineLarge?.copyWith(
            fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1.3, height: 1.05),
        headlineMedium: text.headlineMedium?.copyWith(
            fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.9, height: 1.05),
        headlineSmall: text.headlineSmall?.copyWith(
            fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.8, height: 1.05),
        titleLarge: text.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
        titleMedium: text.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        titleSmall: text.titleSmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 15),
        bodySmall: text.bodySmall?.copyWith(fontSize: 13, color: muted),
        labelSmall: text.labelSmall?.copyWith(
            fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: muted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: ink,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(44, 44),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: background,
          minimumSize: const Size.fromHeight(56),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          backgroundColor: subtle,
          side: BorderSide.none,
          minimumSize: const Size(0, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: link,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.raspberry,
        foregroundColor: Colors.white,
        elevation: 6,
        highlightElevation: 8,
        extendedTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
        shape: StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: subtle,
        hintStyle: TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ink, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: subtle,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.nightSurface : Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: line,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.nightSurface : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: ink,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.nightInk : AppColors.ink,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.ink : Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: ink,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 13,
          color: muted,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.raspberry,
      ),
    );
  }
}
