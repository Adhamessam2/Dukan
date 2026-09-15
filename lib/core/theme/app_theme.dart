import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';
import '../utils/constants.dart';

/// Application Theme Configuration
/// Implements "Warm Architectural Minimalism" for Light and Dark themes.
class AppTheme {
  AppTheme._();

  /// Light Theme Configuration
  static ThemeData get lightTheme => _buildTheme(
        colorScheme: _lightColorScheme,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        scaffoldBackgroundColor: AppColors.lightBackground,
      );

  /// Dark Theme Configuration
  static ThemeData get darkTheme => _buildTheme(
        colorScheme: _darkColorScheme,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        scaffoldBackgroundColor: AppColors.darkBackground,
      );

  // ==========================================
  // COLOR SCHEMES
  // ==========================================
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.lightPrimaryContainer,
    onPrimaryContainer: AppColors.lightOnPrimaryContainer,
    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.lightSecondaryContainer,
    onSecondaryContainer: AppColors.lightOnSecondaryContainer,
    tertiary: AppColors.lightTertiary,
    onTertiary: AppColors.lightOnTertiary,
    tertiaryContainer: AppColors.lightTertiaryContainer,
    onTertiaryContainer: AppColors.lightOnTertiaryContainer,
    error: AppColors.lightError,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.lightErrorContainer,
    onErrorContainer: AppColors.lightOnErrorContainer,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    surfaceDim: AppColors.lightSurfaceDim,
    surfaceBright: AppColors.lightSurfaceBright,
    surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
    surfaceContainerLow: AppColors.lightSurfaceContainerLow,
    surfaceContainer: AppColors.lightSurfaceContainer,
    surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    inverseSurface: AppColors.lightInverseSurface,
    onInverseSurface: AppColors.lightInverseOnSurface,
    inversePrimary: AppColors.lightInversePrimary,
    surfaceTint: AppColors.lightSurfaceTint,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceDim: AppColors.darkSurfaceDim,
    surfaceBright: AppColors.darkSurfaceBright,
    surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
    surfaceContainerLow: AppColors.darkSurfaceContainerLow,
    surfaceContainer: AppColors.darkSurfaceContainer,
    surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    inverseSurface: AppColors.darkInverseSurface,
    onInverseSurface: AppColors.darkInverseOnSurface,
    inversePrimary: AppColors.darkInversePrimary,
    surfaceTint: AppColors.darkSurfaceTint,
  );

  // ==========================================
  // UNIFIED THEME BUILDER (DRY)
  // ==========================================
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required SystemUiOverlayStyle systemOverlayStyle,
    required Color scaffoldBackgroundColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: colorScheme,

      // AppBar Theme (Level 0 base, clean, zero elevation)
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: systemOverlayStyle,
        titleTextStyle: AppTypography.headlineSm.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Text Theme
      textTheme: AppTypography.createTextTheme(color: colorScheme.onSurface),

      // Input Decoration Theme (Height 48px rhythm, surfaceContainerLow well)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        hintStyle: AppTypography.bodyMd.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        labelStyle: AppTypography.labelSm.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: AppTypography.labelSm.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMD,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
      ),

      // Primary CTA Button (52px height, rounded-xl 12px)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLG,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
          textStyle: AppTypography.labelLg,
        ),
      ),

      // Ghost / Tertiary Button Theme (1px hairline outlineVariant border)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: AppConstants.hairlineStrokeWidth,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLG,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          ),
          textStyle: AppTypography.labelLg,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.labelLg,
        ),
      ),

      // Elevated Product Card (Level 2: surfaceContainerLowest + 1px hairline)
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
      ),

      // Bottom Sheet Theme (rounded-3xl: 24px)
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL),
          ),
        ),
      ),

      // Dialog Theme (rounded-3xl: 24px)
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        ),
      ),

      // Chips Theme (rounded-full: 9999px, 36px height)
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.onSurface,
        disabledColor: colorScheme.surfaceDim,
        labelStyle: AppTypography.labelSm.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: AppTypography.labelSm.copyWith(
          color: scaffoldBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMD,
          vertical: 8,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppConstants.iconSizeMD,
      ),

      // Divider Theme (1px hairline)
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: AppConstants.hairlineStrokeWidth,
        space: AppConstants.hairlineStrokeWidth,
      ),
    );
  }
}
