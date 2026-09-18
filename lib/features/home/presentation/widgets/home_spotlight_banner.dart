import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Editorial spotlight banner ("Seasonal Edit: Curated Autumn Drop")
class HomeSpotlightBanner extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const HomeSpotlightBanner({super.key, this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingSM.h,
      ),
      child: Container(
        padding: EdgeInsets.all(AppConstants.spacingLG.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryFixed,
              colorScheme.primaryFixed.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppConstants.elevationLevel2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top tag
            Row(
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'SEASONAL EDIT',
                  style: TextStyle(
                    color: colorScheme.onPrimaryFixed,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppConstants.spacingSM.h),

            // Headline
            Text(
              'Curated Autumn Drop',
              style: TextStyle(
                color: colorScheme.onPrimaryFixed,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),

            SizedBox(height: AppConstants.spacingXS.h),

            // Subtitle
            Text(
              'Tactile modern essentials shaped by quiet craftsmanship and unhurried design.',
              style: TextStyle(
                color: colorScheme.onPrimaryFixedVariant,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),

            SizedBox(height: AppConstants.spacingMD.h),

            // CTA Button
            InkWell(
              onTap: onExploreTap,
              borderRadius: BorderRadius.circular(AppConstants.radiusRound),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                  boxShadow: AppConstants.elevationLevel2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Edit',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colorScheme.onPrimary,
                      size: 14.r,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
