import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button.dart';

/// Sticky bottom bar with "Reorder All Items" primary CTA and "Need Help with this Order?" link,
/// or "Pay Now" and "Cancel Order" when payment is pending.
/// Wrapped in RepaintBoundary and SafeArea for optimal rendering performance.
/// Matching Figma node 1:1306.
class OrderDetailsBottomBar extends StatelessWidget {
  final VoidCallback? onReorderAllPressed;
  final VoidCallback? onNeedHelpPressed;
  final VoidCallback? onPayNowPressed;
  final VoidCallback? onCancelOrderPressed;
  final bool isReordering;
  final bool isCancelling;
  final bool isPendingPayment;
  final double? totalAmount;

  const OrderDetailsBottomBar({
    super.key,
    this.onReorderAllPressed,
    this.onNeedHelpPressed,
    this.onPayNowPressed,
    this.onCancelOrderPressed,
    this.isReordering = false,
    this.isCancelling = false,
    this.isPendingPayment = false,
    this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: AppConstants.hairlineStrokeWidth,
            ),
          ),
          boxShadow: AppConstants.elevationLevel3,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingSM.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPendingPayment) ...[
                  // Pay Now Primary CTA
                  CustomButton(
                    text: totalAmount != null
                        ? 'Pay Now • \$${totalAmount!.toStringAsFixed(2)}'
                        : 'Pay Now',
                    onPressed: onPayNowPressed,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: AppConstants.iconSizeSM.r,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacingXS.h),

                  // Cancel Order Secondary Action
                  TextButton.icon(
                    onPressed: isCancelling ? null : onCancelOrderPressed,
                    icon: isCancelling
                        ? SizedBox(
                            width: AppConstants.iconSizeSM.r,
                            height: AppConstants.iconSizeSM.r,
                            child: CircularProgressIndicator(
                              strokeWidth: AppConstants.hairlineStrokeWidth * 2,
                              color: colorScheme.error,
                            ),
                          )
                        : Icon(
                            Icons.cancel_outlined,
                            size: AppConstants.iconSizeSM.r,
                            color: colorScheme.error,
                          ),
                    label: Text(
                      'Cancel Order',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else ...[
                  // Reorder All Items CTA
                  CustomButton(
                    text: 'Reorder All Items',
                    onPressed: onReorderAllPressed,
                    isLoading: isReordering,
                    prefixIcon: Icon(
                      Icons.replay_rounded,
                      size: AppConstants.iconSizeSM.r,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacingXS.h),

                  // Need Help Link
                  TextButton.icon(
                    onPressed: onNeedHelpPressed,
                    icon: Icon(
                      Icons.headset_mic_outlined,
                      size: AppConstants.iconSizeSM.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    label: Text(
                      'Need Help with this Order?',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
