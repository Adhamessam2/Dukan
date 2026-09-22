import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Checkout step indicator showing current stage and subtitle description.
/// Wrapped in RepaintBoundary for repaint isolation per AGENTS.md.
class CheckoutStepIndicator extends StatelessWidget {
  const CheckoutStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.margin.w,
          vertical: AppConstants.spacingSM.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Final Step',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 22.sp,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppConstants.spacingSM.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingSM.w,
                    vertical: AppConstants.spacingXS.h / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusRound,
                    ),
                  ),
                  child: Text(
                    'Step 2 of 2',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppConstants.spacingXS.h),
            Container(
              width: AppConstants.avatarSizeMD.w,
              height: AppConstants.hairlineStrokeWidth * 3,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
              ),
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            Text(
              'Review your shipping details & confirm payment',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
