import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Trust badges displaying security and return guarantees matching Figma #1:609.
/// Wrapped in RepaintBoundary to prevent repaint thrashing during scrolling.
class CartTrustBadges extends StatelessWidget {
  const CartTrustBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.margin.w,
          vertical: AppConstants.spacingMD.h,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Secure Checkout
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: AppConstants.spacingXS.w),
                  Text(
                    'Secure 256-bit Checkout',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Divider Dot
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                ),
                child: Container(
                  width: AppConstants.spacingXS.r,
                  height: AppConstants.spacingXS.r,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Free 30-Day Returns
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.replay_rounded,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: AppConstants.spacingXS.w),
                  Text(
                    'Free 30-Day Returns',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
