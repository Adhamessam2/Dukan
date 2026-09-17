import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';

/// Brand Mascot and Delight Header conforming to "Warm Architectural Minimalism".
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Mascot Logo with Warm Glow Blur
        SizedBox(
          width: 88.w,
          height: 88.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient warm glow backdrop (vector BoxShadow, 0 GPU saveLayer cost)
              Container(
                width: 88.w,
                height: 88.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 16.r,
                      spreadRadius: 4.r,
                    ),
                  ],
                ),
              ),
              // Dukaan Shopping Bag Logo
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/dukaan_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppConstants.spaceMD.h),
        // Dukaan Brand Heading
        Text(
          'Dukaan',
          style: AppTypography.displayLgMobile.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6.h),
        // Subtitle
        Text(
          'Thoughtful everyday essentials',
          style: AppTypography.bodyMd.copyWith(
            color: colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
