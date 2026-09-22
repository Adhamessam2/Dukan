import 'package:flutter/material.dart';

/// Application Constants
/// Centralized constant definitions & Design System specifications
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = 'v1';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String onboardingKey = 'onboarding_completed';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // ==========================================
  // DESIGN SYSTEM: SPACING (4px/8px incremental rhythm)
  // ==========================================
  static const double gutter = 12.0; // 0.75rem
  static const double margin = 16.0; // 1.0rem
  static const double spacingXS = 4.0; // 0.25rem
  static const double spacingSM = 8.0; // 0.5rem
  static const double spacingMD = 16.0; // 1.0rem
  static const double spacingLG = 24.0; // 1.5rem
  static const double spacingXL = 32.0; // 2.0rem

  static const double spaceXS = spacingXS;
  static const double spaceSM = spacingSM;
  static const double spaceMD = spacingMD;
  static const double spaceLG = spacingLG;
  static const double spaceXL = spacingXL;

  // ==========================================
  // DESIGN SYSTEM: BORDER RADIUS
  // ==========================================
  static const double radiusSM = 4.0; // 0.25rem
  static const double radiusDefault = 8.0; // 0.5rem
  static const double radiusMD = 12.0; // 0.75rem (rounded-xl: buttons, inputs)
  static const double radiusLG = 16.0; // 1.0rem (rounded-2xl: product cards)
  static const double radiusXL =
      24.0; // 1.5rem (rounded-3xl: modal sheets, containers)
  static const double radiusFull = 9999.0;
  static const double radiusRound = 9999.0;

  // Responsive Design Sizes
  static const Size designSizePortrait = Size(375, 812);
  static const Size designSizeLandscape = Size(812, 375);

  // ==========================================
  // DESIGN SYSTEM: COMPONENT SIZING & STROKES
  // ==========================================
  static const double headerHeight = 64.0;
  static const double minHeaderHeight = 56.0;
  static const double maxHeaderHeight = 72.0;
  static const double bottomNavBarHeight = 64.0;
  static const double searchBarHeight = 44.0;
  static const double buttonHeight = 52.0;
  static const double inputHeight = 48.0;
  static const double chipHeight = 36.0;
  static const double stepperHeight = 36.0;
  static const double productHeroHeight = 320.0;
  static const double hairlineStrokeWidth = 1.0;
  static const double controlSize = 20.0;
  static const double cartImageWidth = 80.0;
  static const double cartImageHeight = 96.0;
  static const double stepperButtonSize = 24.0;
  static const double indicatorDotSize = 6.0;

  // ==========================================
  // DESIGN SYSTEM: ELEVATION SHADOWS
  // ==========================================
  /// Level 2: Elevated Product Card on hover/active
  static const List<BoxShadow> elevationLevel2 = [
    BoxShadow(
      color: Color.fromRGBO(24, 24, 27, 0.04),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  /// Level 3: Floating Bars & Bottom Sticky Trays
  static const List<BoxShadow> elevationLevel3 = [
    BoxShadow(
      color: Color.fromRGBO(24, 24, 27, 0.05),
      blurRadius: 32,
      offset: Offset(0, -8),
    ),
  ];

  /// Level 4: Modals & Action Sheets
  static const List<BoxShadow> elevationLevel4 = [
    BoxShadow(
      color: Color.fromRGBO(24, 24, 27, 0.12),
      blurRadius: 40,
      spreadRadius: -8,
      offset: Offset(0, 20),
    ),
  ];

  // Icon Sizes
  static const double iconSizeSM = 16.0;
  static const double iconSizeMD = 24.0;
  static const double iconSizeLG = 32.0;
  static const double iconSizeXL = 48.0;

  // Image Sizes
  static const double avatarSizeSM = 32.0;
  static const double avatarSizeMD = 48.0;
  static const double avatarSizeLG = 64.0;
  static const double avatarSizeXL = 96.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
  ];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx'];

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Regular Expressions
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
  static final RegExp urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );
  static final RegExp htmlBoldRegex = RegExp(
    r'<b>(.*?)<\/b>|([^<]+)',
    dotAll: true,
  );

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'No internet connection. Please check your network.';
  static const String timeoutErrorMessage =
      'Request timeout. Please try again.';
  static const String unauthorizedErrorMessage =
      'Unauthorized. Please login again.';
}
