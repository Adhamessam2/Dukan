import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/payment_method.dart';

/// Sticky bottom bar displaying the grand total and primary checkout CTA button.
/// Conforms to AGENTS.md: RepaintBoundary, pure Theme.of(context) tokens, AppConstants.
class CheckoutStickyBottomBar extends StatelessWidget {
  final double totalPrice;
  final PaymentMethod paymentMethod;
  final bool isLoading;
  final VoidCallback? onSubmitPressed;

  const CheckoutStickyBottomBar({
    super.key,
    required this.totalPrice,
    required this.paymentMethod,
    this.isLoading = false,
    this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String buttonText = switch (paymentMethod) {
      PaymentMethod.creditCard =>
        'Pay with Card – \$${totalPrice.toStringAsFixed(2)}',
      PaymentMethod.cash =>
        'Pay with Cash – \$${totalPrice.toStringAsFixed(2)}',
    };

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
              vertical: AppConstants.spacingSM.h + AppConstants.spacingXS.h,
            ),
            child: Row(
              children: [
                // Left Column: TOTAL label + price
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: AppConstants.spacingXS.h / 2),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppConstants.spacingMD.w),

                // Right CTA Button
                Expanded(
                  child: CustomButton(
                    text: buttonText,
                    isLoading: isLoading,
                    onPressed: onSubmitPressed,
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: AppConstants.iconSizeSM.r,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
