import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Floating checkout action tray fixed above navigation bar, matching Figma #1:621.
/// Implements GPU-safe vector BoxShadow (anti-jank compliant per AGENTS.md).
class CartStickyCheckoutBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback? onCheckoutPressed;

  const CartStickyCheckoutBar({
    super.key,
    required this.totalPrice,
    this.onCheckoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingSM.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        boxShadow: AppConstants.elevationLevel3,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppConstants.buttonHeight.h.clamp(
            AppConstants.searchBarHeight,
            AppConstants.buttonHeight,
          ),
          child: Material(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
            elevation: 0,
            child: InkWell(
              onTap: onCheckoutPressed,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.margin.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Icon + Label
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: AppConstants.iconSizeSM.r + 2.r,
                            color: colorScheme.onPrimary,
                          ),
                          SizedBox(width: AppConstants.spacingSM.w),
                          Expanded(
                            child: Text(
                              'Proceed to Checkout',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppConstants.spacingSM.w),

                    // Right: Price + Arrow
                    Row(
                      children: [
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: AppConstants.spacingXS.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppConstants.iconSizeSM.r,
                          color: colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
