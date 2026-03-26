import 'package:flutter/material.dart';

/// Centralized design tokens derived from the Stitch design system.
///
/// Color palette: "The Digital Curator" — teal-accented dark mode.
/// Typography: Newsreader (headlines), Inter (body/labels).
/// Geometry: 8dp standard radius, tonal surface layering.
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────
  static const primary = Color(0xFF66D9CC);
  static const primaryContainer = Color(0xFF008177);
  static const onPrimary = Color(0xFF003732);
  static const onPrimaryContainer = Color(0xFFE4FFFA);

  // ── Secondary ────────────────────────────────────────────
  static const secondary = Color(0xFFAACDCC);
  static const secondaryContainer = Color(0xFF2D4F4E);
  static const onSecondary = Color(0xFF133635);
  static const onSecondaryContainer = Color(0xFF9CBFBE);

  // ── Tertiary (warm accent) ───────────────────────────────
  static const tertiary = Color(0xFFFFB692);
  static const tertiaryContainer = Color(0xFFA96039);
  static const onTertiary = Color(0xFF552000);
  static const onTertiaryContainer = Color(0xFFFFF9F7);

  // ── Error ────────────────────────────────────────────────
  static const error = Color(0xFFFFB4AB);
  static const errorContainer = Color(0xFF93000A);
  static const onError = Color(0xFF690005);
  static const onErrorContainer = Color(0xFFFFDAD6);

  // ── Surface tiers (tonal layering) ───────────────────────
  static const surface = Color(0xFF131313);
  static const surfaceDim = Color(0xFF131313);
  static const surfaceBright = Color(0xFF393939);
  static const surfaceContainerLowest = Color(0xFF0E0E0E);
  static const surfaceContainerLow = Color(0xFF1C1B1B);
  static const surfaceContainer = Color(0xFF201F1F);
  static const surfaceContainerHigh = Color(0xFF2A2A2A);
  static const surfaceContainerHighest = Color(0xFF353534);
  static const surfaceVariant = Color(0xFF353534);
  static const onSurface = Color(0xFFE5E2E1);
  static const onSurfaceVariant = Color(0xFFBDC9C8);

  // ── Background (same as surface in Material 3) ──────────
  static const background = Color(0xFF131313);
  static const onBackground = Color(0xFFE5E2E1);

  // ── Outline ──────────────────────────────────────────────
  static const outline = Color(0xFF879392);
  static const outlineVariant = Color(0xFF3E4949);

  // ── Inverse ──────────────────────────────────────────────
  static const inverseSurface = Color(0xFFE5E2E1);
  static const inverseOnSurface = Color(0xFF313030);
  static const inversePrimary = Color(0xFF006A62);

  // ── Surface tint ─────────────────────────────────────────
  static const surfaceTint = Color(0xFF66D9CC);

  // ── Semantic colors (for use in widgets) ─────────────────
  static const success = Color(0xFF66D9CC); // Use primary for success
  static const successContainer = Color(0xFF008177);

  // ── Tone indicator colors (AI insight panel) ─────────────
  static const toneNeutral = Color(0xFF879392);
  static const toneCritical = Color(0xFFFFB692);
  static const toneSupportive = Color(0xFF66D9CC);
  static const toneAlarming = Color(0xFFFFB4AB);
  static const toneOptimistic = Color(0xFFAACDCC);
  static const toneAnalytical = Color(0xFF9CBFBE);

  // ── Light theme overrides ────────────────────────────────
  static const lightPrimary = Color(0xFF006A62);
  static const lightPrimaryContainer = Color(0xFF84F5E8);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightOnPrimaryContainer = Color(0xFF00201D);
  static const lightSecondary = Color(0xFF2D4F4E);
  static const lightSecondaryContainer = Color(0xFFC5E9E9);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightOnSecondaryContainer = Color(0xFF002020);
  static const lightSurface = Color(0xFFFBF9F8);
  static const lightSurfaceContainer = Color(0xFFF0EDEC);
  static const lightSurfaceContainerLow = Color(0xFFF5F3F2);
  static const lightSurfaceContainerHigh = Color(0xFFEAE8E6);
  static const lightSurfaceContainerHighest = Color(0xFFE5E2E1);
  static const lightOnSurface = Color(0xFF1C1B1B);
  static const lightOnSurfaceVariant = Color(0xFF3E4949);
  static const lightBackground = Color(0xFFFBF9F8);
  static const lightOnBackground = Color(0xFF1C1B1B);
  static const lightOutline = Color(0xFF879392);
  static const lightOutlineVariant = Color(0xFFBDC9C8);
  static const lightError = Color(0xFFBA1A1A);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightOnErrorContainer = Color(0xFF410002);
  static const lightInverseSurface = Color(0xFF313030);
  static const lightInverseOnSurface = Color(0xFFF3F0EF);
  static const lightInversePrimary = Color(0xFF66D9CC);
}

/// Standard border radii from the Stitch geometry spec (ROUND_EIGHT).
abstract final class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 9999.0;

  static final BorderRadius xsBorder = BorderRadius.circular(xs);
  static final BorderRadius smBorder = BorderRadius.circular(sm);
  static final BorderRadius mdBorder = BorderRadius.circular(md);
  static final BorderRadius lgBorder = BorderRadius.circular(lg);
  static final BorderRadius xlBorder = BorderRadius.circular(xl);
  static final BorderRadius fullBorder = BorderRadius.circular(full);
}

/// Standard spacing scale.
abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Font family names for Google Fonts usage.
abstract final class AppFonts {
  static const String headline = 'Newsreader';
  static const String body = 'Inter';
  static const String label = 'Inter';
}

/// Gradient definitions from the Stitch "Glass & Gradient" rule.
abstract final class AppGradients {
  /// Primary CTA gradient (teal 135°).
  static const LinearGradient primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );

  /// Surface fade for hero images.
  static const LinearGradient heroFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, AppColors.surface],
  );
}
