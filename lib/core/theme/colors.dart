import 'package:flutter/material.dart';

/// Application Color Tokens & Palettes
/// Implements the "Warm Architectural Minimalism" design system.
class AppColors {
  AppColors._();

  // ==========================================
  // LIGHT PALETTE TOKENS
  // ==========================================
  static const Color lightSurface = Color(0xFFF9F9F9);
  static const Color lightSurfaceDim = Color(0xFFDADADA);
  static const Color lightSurfaceBright = Color(0xFFF9F9F9);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFF3F3F3);
  static const Color lightSurfaceContainer = Color(0xFFEEEEEE);
  static const Color lightSurfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color lightSurfaceContainerHighest = Color(0xFFE2E2E2);
  static const Color lightOnSurface = Color(0xFF1A1C1C);
  static const Color lightOnSurfaceVariant = Color(0xFF59413A);
  static const Color lightInverseSurface = Color(0xFF2F3131);
  static const Color lightInverseOnSurface = Color(0xFFF0F1F1);
  static const Color lightOutline = Color(0xFF8D7168);
  static const Color lightOutlineVariant = Color(0xFFE1BFB5);
  static const Color lightSurfaceTint = Color(0xFFAB3504);
  static const Color lightPrimary = Color(0xFFA83301);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFCA4A1C);
  static const Color lightOnPrimaryContainer = Color(0xFFFFFBFF);
  static const Color lightInversePrimary = Color(0xFFFFB59D);
  static const Color lightSecondary = Color(0xFF5F5E61);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFE4E1E6);
  static const Color lightOnSecondaryContainer = Color(0xFF656467);
  static const Color lightTertiary = Color(0xFF5A5C5D);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFF737576);
  static const Color lightOnTertiaryContainer = Color(0xFFFCFCFD);
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnErrorContainer = Color(0xFF93000A);
  static const Color lightPrimaryFixed = Color(0xFFFFDBD0);
  static const Color lightPrimaryFixedDim = Color(0xFFFFB59D);
  static const Color lightOnPrimaryFixed = Color(0xFF390B00);
  static const Color lightOnPrimaryFixedVariant = Color(0xFF842500);
  static const Color lightSecondaryFixed = Color(0xFFE4E1E6);
  static const Color lightSecondaryFixedDim = Color(0xFFC8C5CA);
  static const Color lightOnSecondaryFixed = Color(0xFF1B1B1E);
  static const Color lightOnSecondaryFixedVariant = Color(0xFF47464A);
  static const Color lightTertiaryFixed = Color(0xFFE2E2E3);
  static const Color lightTertiaryFixedDim = Color(0xFFC6C6C7);
  static const Color lightOnTertiaryFixed = Color(0xFF1A1C1D);
  static const Color lightOnTertiaryFixedVariant = Color(0xFF454748);
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color lightOnBackground = Color(0xFF1A1C1C);
  static const Color lightSurfaceVariant = Color(0xFFE2E2E2);

  // ==========================================
  // DARK PALETTE TOKENS
  // ==========================================
  static const Color darkSurface = Color(0xFF131313);
  static const Color darkSurfaceDim = Color(0xFF131313);
  static const Color darkSurfaceBright = Color(0xFF393939);
  static const Color darkSurfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color darkSurfaceContainerLow = Color(0xFF1C1B1B);
  static const Color darkSurfaceContainer = Color(0xFF201F1F);
  static const Color darkSurfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color darkSurfaceContainerHighest = Color(0xFF353534);
  static const Color darkOnSurface = Color(0xFFE5E2E1);
  static const Color darkOnSurfaceVariant = Color(0xFFE0C0B5);
  static const Color darkInverseSurface = Color(0xFFE5E2E1);
  static const Color darkInverseOnSurface = Color(0xFF313030);
  static const Color darkOutline = Color(0xFFA78A81);
  static const Color darkOutlineVariant = Color(0xFF58423A);
  static const Color darkSurfaceTint = Color(0xFFFFB59C);
  static const Color darkPrimary = Color(0xFFFFB59C);
  static const Color darkOnPrimary = Color(0xFF5C1900);
  static const Color darkPrimaryContainer = Color(0xFFF06A38);
  static const Color darkOnPrimaryContainer = Color(0xFF541600);
  static const Color darkInversePrimary = Color(0xFFA93804);
  static const Color darkSecondary = Color(0xFFFFB59D);
  static const Color darkOnSecondary = Color(0xFF5D1800);
  static const Color darkSecondaryContainer = Color(0xFFA83301);
  static const Color darkOnSecondaryContainer = Color(0xFFFFC8B8);
  static const Color darkTertiary = Color(0xFFC8C6C6);
  static const Color darkOnTertiary = Color(0xFF303030);
  static const Color darkTertiaryContainer = Color(0xFF949393);
  static const Color darkOnTertiaryContainer = Color(0xFF2C2C2C);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);
  static const Color darkPrimaryFixed = Color(0xFFFFDBCF);
  static const Color darkPrimaryFixedDim = Color(0xFFFFB59C);
  static const Color darkOnPrimaryFixed = Color(0xFF390C00);
  static const Color darkOnPrimaryFixedVariant = Color(0xFF822700);
  static const Color darkSecondaryFixed = Color(0xFFFFDBD0);
  static const Color darkSecondaryFixedDim = Color(0xFFFFB59D);
  static const Color darkOnSecondaryFixed = Color(0xFF390B00);
  static const Color darkOnSecondaryFixedVariant = Color(0xFF842500);
  static const Color darkTertiaryFixed = Color(0xFFE4E2E1);
  static const Color darkTertiaryFixedDim = Color(0xFFC8C6C6);
  static const Color darkOnTertiaryFixed = Color(0xFF1B1C1C);
  static const Color darkOnTertiaryFixedVariant = Color(0xFF474747);
  static const Color darkBackground = Color(0xFF131313);
  static const Color darkOnBackground = Color(0xFFE5E2E1);
  static const Color darkSurfaceVariant = Color(0xFF353534);

  // ==========================================
  // CANONICAL DEFAULT & BACKWARD-COMPATIBLE ALIASES
  // (Defaults reference Light Palette per merge rules)
  // ==========================================
  static const Color primary = lightPrimary;
  static const Color primaryDark = Color(0xFF842500);
  static const Color primaryLight = lightPrimaryFixed;

  static const Color secondary = lightSecondary;
  static const Color secondaryDark = lightSecondaryContainer;
  static const Color secondaryLight = lightSecondaryFixed;

  static const Color accent = lightPrimaryContainer;
  static const Color accentDark = lightPrimary;
  static const Color accentLight = lightInversePrimary;

  static const Color background = lightBackground;
  static const Color backgroundDark = darkBackground;
  static const Color surface = lightSurface;
  static const Color surfaceDark = darkSurface;

  // Text Colors
  static const Color textPrimary = lightOnSurface;
  static const Color textSecondary = lightOnSurfaceVariant;
  static const Color textLight = lightOutline;
  static const Color textOnPrimary = lightOnPrimary;

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color error = lightError;
  static const Color info = Color(0xFF0288D1);

  // Border & Divider Colors
  static const Color border = lightOutlineVariant;
  static const Color divider = lightOutlineVariant;

  // Gradients (Warm Architectural Terracotta)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPrimary, lightPrimaryContainer],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPrimaryContainer, lightPrimaryFixedDim],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBackground, darkSurfaceContainer],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
  );
}
