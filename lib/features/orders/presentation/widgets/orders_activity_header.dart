import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Activity & "My Orders" hero title header matching Figma node 1:1090.
/// Displays overline "ACTIVITY", headline "My Orders", and optional active shipment badge pill.
class OrdersActivityHeader extends StatelessWidget {
  final int activeShipmentsCount;

  const OrdersActivityHeader({super.key, required this.activeShipmentsCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Overline
        Text(
          'ACTIVITY',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: (AppConstants.spacingXS / 2).h),

        // Headline & Active shipment pill
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'My Orders',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (activeShipmentsCount > 0) ...[
              SizedBox(width: AppConstants.spacingSM.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                  vertical: (AppConstants.spacingXS / 1.5).h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusFull.r,
                  ),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                    width: AppConstants.hairlineStrokeWidth,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppConstants.indicatorDotSize.r,
                      height: AppConstants.indicatorDotSize.r,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppConstants.spacingXS.w),
                    Text(
                      '$activeShipmentsCount active shipment${activeShipmentsCount > 1 ? 's' : ''}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
