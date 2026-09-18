import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application Typography
/// Implements the "Warm Architectural Minimalism" typographic system with Plus Jakarta Sans.
class AppTypography {
  AppTypography._();

  // Base Font Family
  static String? get fontFamily => GoogleFonts.plusJakartaSans().fontFamily;

  // ==========================================
  // DESIGN SYSTEM TOKENS (Plus Jakarta Sans)
  // ==========================================

  /// Display Large: 36px (2.25rem), Bold, LineHeight 44px (1.22), Tracking -0.03em
  static TextStyle displayLg = GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.03 * 36,
  );

  /// Display Large Mobile: 30px (1.875rem), Bold, LineHeight 36px (1.2), Tracking -0.025em
  static TextStyle displayLgMobile = GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 36 / 30,
    letterSpacing: -0.025 * 30,
  );

  /// Headline Large: 24px (1.5rem), SemiBold, LineHeight 32px (1.33), Tracking -0.02em
  static TextStyle headlineLg = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.02 * 24,
  );

  /// Headline Medium: 20px (1.25rem), SemiBold, LineHeight 28px (1.4), Tracking -0.015em
  static TextStyle headlineMd = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.015 * 20,
  );

  /// Headline Small: 18px (1.125rem), SemiBold, LineHeight 24px (1.33), Tracking -0.01em
  static TextStyle headlineSm = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.01 * 18,
  );

  /// Body Large: 16px (1rem), Regular, LineHeight 24px (1.5), Tracking -0.005em
  static TextStyle bodyLg = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: -0.005 * 16,
  );

  /// Body Medium: 14px (0.875rem), Regular, LineHeight 22px (1.57), Tracking 0.0em
  static TextStyle bodyMd = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
    letterSpacing: 0,
  );

  /// Body Small: 12px (0.75rem), Regular, LineHeight 18px (1.5), Tracking 0.01em
  static TextStyle bodySm = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    letterSpacing: 0.01 * 12,
  );

  /// Label Large: 14px (0.875rem), SemiBold, LineHeight 20px (1.43), Tracking 0.01em
  static TextStyle labelLg = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.01 * 14,
  );

  /// Label Medium: 12px (0.75rem), SemiBold, LineHeight 16px (1.33), Tracking 0.02em
  static TextStyle labelMd = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.02 * 12,
  );

  /// Label Small: 11px (0.6875rem), SemiBold, LineHeight 14px (1.27), Tracking 0.04em
  static TextStyle labelSm = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    letterSpacing: 0.04 * 11,
  );

  // ==========================================
  // TABULAR FIGURES (Pricing, Quantity, Counters)
  // ==========================================
  static TextStyle tabular(TextStyle style) =>
      style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  static TextStyle get tabularHeadlineSm => tabular(headlineSm);
  static TextStyle get tabularHeadlineMd => tabular(headlineMd);
  static TextStyle get tabularLabelLg => tabular(labelLg);
  static TextStyle get tabularBodyMd => tabular(bodyMd);

  // ==========================================
  // BACKWARD-COMPATIBLE ALIASES
  // ==========================================
  static TextStyle get h1 => displayLg;
  static TextStyle get h2 => headlineLg;
  static TextStyle get h3 => headlineMd;
  static TextStyle get h4 => headlineSm;
  static TextStyle get h5 => bodyLg.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get h6 => bodyMd.copyWith(fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge => bodyLg;
  static TextStyle get bodyMedium => bodyMd;
  static TextStyle get bodySmall => bodySm;

  static TextStyle get button => labelLg;
  static TextStyle get caption => bodySm;
  static TextStyle get overline => labelSm;

  static TextStyle get labelLarge => labelLg;
  static TextStyle get labelMedium => labelMd;
  static TextStyle get labelSmall => labelSm;

  /// Builds a full Flutter TextTheme matching the design system
  static TextTheme createTextTheme({Color? color}) {
    final baseTheme = GoogleFonts.plusJakartaSansTextTheme();
    if (color == null) {
      return baseTheme.copyWith(
        displayLarge: displayLg,
        displayMedium: displayLgMobile,
        displaySmall: headlineLg,
        headlineLarge: headlineLg,
        headlineMedium: headlineMd,
        headlineSmall: headlineSm,
        titleLarge: headlineSm,
        titleMedium: bodyLg.copyWith(fontWeight: FontWeight.w600),
        titleSmall: bodyMd.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: bodyLg,
        bodyMedium: bodyMd,
        bodySmall: bodySm,
        labelLarge: labelLg,
        labelMedium: labelMd,
        labelSmall: labelSm,
      );
    }
    return baseTheme
        .apply(bodyColor: color, displayColor: color)
        .copyWith(
          displayLarge: displayLg.copyWith(color: color),
          displayMedium: displayLgMobile.copyWith(color: color),
          displaySmall: headlineLg.copyWith(color: color),
          headlineLarge: headlineLg.copyWith(color: color),
          headlineMedium: headlineMd.copyWith(color: color),
          headlineSmall: headlineSm.copyWith(color: color),
          titleLarge: headlineSm.copyWith(color: color),
          titleMedium: bodyLg.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: bodyMd.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: bodyLg.copyWith(color: color),
          bodyMedium: bodyMd.copyWith(color: color),
          bodySmall: bodySm.copyWith(color: color),
          labelLarge: labelLg.copyWith(color: color),
          labelMedium: labelMd.copyWith(color: color),
          labelSmall: labelSm.copyWith(color: color),
        );
  }
}

/// Extension for convenient tabular figures modifier
extension TextStyleDesignSystemExt on TextStyle {
  TextStyle withTabularFigures() =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
