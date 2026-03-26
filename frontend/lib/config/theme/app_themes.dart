import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';

/// Dark theme — the primary Stitch "Digital Curator" editorial design.
ThemeData darkTheme() {
  final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
  final headlineTextTheme = GoogleFonts.newsreaderTextTheme(
    ThemeData.dark().textTheme,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      onPrimary: AppColors.onPrimary,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondary: AppColors.onSecondary,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiary: AppColors.onTertiary,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      onError: AppColors.onError,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      // surfaceContainer* not available in Flutter 3.19 ColorScheme —
      // use AppColors.* directly in widgets instead.
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
      surfaceTint: AppColors.surfaceTint,
    ),
    textTheme: baseTextTheme.copyWith(
      displayLarge: headlineTextTheme.displayLarge?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      displayMedium: headlineTextTheme.displayMedium?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      displaySmall: headlineTextTheme.displaySmall?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      headlineLarge: headlineTextTheme.headlineLarge?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: headlineTextTheme.headlineMedium?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: headlineTextTheme.headlineSmall?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: headlineTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      titleMedium: baseTextTheme.titleMedium,
      titleSmall: baseTextTheme.titleSmall,
      bodyLarge: baseTextTheme.bodyLarge,
      bodyMedium: baseTextTheme.bodyMedium,
      bodySmall: baseTextTheme.bodySmall,
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        letterSpacing: 0.5,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        letterSpacing: 1.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
      titleTextStyle: GoogleFonts.newsreader(
        color: AppColors.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceContainerLowest,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Color(0x99E5E2E1), // onSurface at 60%
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHighest,
      selectedColor: AppColors.primary,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.fullBorder,
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    cardTheme: CardTheme(
      color: AppColors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdBorder,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdBorder,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(
        color: Color(0x80879392), // outline at 50%
      ),
      labelStyle: const TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.surfaceContainerHigh,
        disabledForegroundColor: AppColors.onSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.fullBorder,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.fullBorder,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      contentTextStyle: const TextStyle(color: AppColors.onSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.smBorder,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgBorder,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.outlineVariant.withOpacity(0.3),
      thickness: 1,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.onSurface,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
  );
}

/// Light theme — editorial style with teal accents.
ThemeData lightTheme() {
  final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);
  final headlineTextTheme = GoogleFonts.newsreaderTextTheme(
    ThemeData.light().textTheme,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimary: AppColors.lightOnPrimary,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondary: AppColors.lightOnSecondary,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,
      error: AppColors.lightError,
      errorContainer: AppColors.lightErrorContainer,
      onError: AppColors.lightOnError,
      onErrorContainer: AppColors.lightOnErrorContainer,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      // surfaceContainer* not available in Flutter 3.19 ColorScheme.
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      inverseSurface: AppColors.lightInverseSurface,
      onInverseSurface: AppColors.lightInverseOnSurface,
      inversePrimary: AppColors.lightInversePrimary,
    ),
    textTheme: baseTextTheme.copyWith(
      displayLarge: headlineTextTheme.displayLarge?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      displayMedium: headlineTextTheme.displayMedium?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      displaySmall: headlineTextTheme.displaySmall?.copyWith(
        fontStyle: FontStyle.italic,
      ),
      headlineLarge: headlineTextTheme.headlineLarge?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: headlineTextTheme.headlineMedium?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: headlineTextTheme.headlineSmall?.copyWith(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: headlineTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.lightOnSurface),
      titleTextStyle: GoogleFonts.newsreader(
        color: AppColors.lightOnSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: Color(0x991C1B1B), // lightOnSurface at 60%
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceContainerHighest,
      selectedColor: AppColors.lightPrimary,
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.fullBorder,
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    cardTheme: CardTheme(
      color: AppColors.lightSurfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdBorder,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.lightOnPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdBorder,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceContainer,
      border: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: const BorderSide(
          color: AppColors.lightPrimary,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: const BorderSide(
          color: AppColors.lightError,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdBorder,
        borderSide: const BorderSide(
          color: AppColors.lightError,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        disabledBackgroundColor: AppColors.lightSurfaceContainerHigh,
        disabledForegroundColor: AppColors.lightOnSurfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.fullBorder,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: BorderSide(
          color: AppColors.lightPrimary.withOpacity(0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.fullBorder,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightInverseSurface,
      contentTextStyle: const TextStyle(color: AppColors.lightInverseOnSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.smBorder,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.lightSurfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgBorder,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightOutlineVariant.withOpacity(0.3),
      thickness: 1,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightOnSurface,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.lightPrimary,
    ),
  );
}

// Keep backward compatibility — theme() returns lightTheme.
ThemeData theme() => lightTheme();
