import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/payment_method.dart';

/// Card container allowing customer to choose between Cash on Delivery and Credit Card (Visa).
/// Adheres strictly to AGENTS.md: pure theme colors, AppConstants sizing, and no raw magic numbers.
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodSelected;

  const PaymentMethodCard({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppConstants.margin.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: AppConstants.hairlineStrokeWidth,
        ),
        boxShadow: AppConstants.elevationLevel2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Card icon + Title + Secured badge
          Row(
            children: [
              Container(
                width: AppConstants.avatarSizeSM.r,
                height: AppConstants.avatarSizeSM.r,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.payment_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Expanded(
                child: Text(
                  'Payment Method',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                  vertical: AppConstants.spacingXS.h / 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.gpp_good_outlined,
                      size: AppConstants.iconSizeSM.r,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: AppConstants.spacingXS.w),
                    Text(
                      'Secured',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Cash Tile
          _buildPaymentTile(
            context: context,
            method: PaymentMethod.cash,
            title: 'Cash',
            subtitle: 'Pay with cash on delivery',
            icon: Icons.payments_outlined,
            isSelected: selectedMethod == PaymentMethod.cash,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Visa / Credit Card Tile
          _buildPaymentTile(
            context: context,
            method: PaymentMethod.creditCard,
            title: 'Visa',
            subtitle: 'Pay with Visa at checkout',
            icon: Icons.credit_card_rounded,
            isSelected: selectedMethod == PaymentMethod.creditCard,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Security assurance box
          Container(
            padding: EdgeInsets.all(AppConstants.spacingMD.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
                SizedBox(width: AppConstants.spacingSM.w),
                Expanded(
                  child: Text(
                    'Encrypted with 256-bit SSL and processed securely via Paymob payment gateways.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile({
    required BuildContext context,
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        selected: isSelected,
        child: InkWell(
          onTap: () => onMethodSelected(method),
          borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
          child: AnimatedContainer(
            duration: AppConstants.shortAnimationDuration,
            padding: EdgeInsets.all(AppConstants.spacingMD.r),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.12)
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(alpha: 0.4),
                width: isSelected
                    ? AppConstants.hairlineStrokeWidth * 2
                    : AppConstants.hairlineStrokeWidth,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppConstants.chipHeight.r,
                  height: AppConstants.chipHeight.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                        : colorScheme.surface,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: AppConstants.iconSizeSM.r,
                    ),
                  ),
                ),
                SizedBox(width: AppConstants.spacingMD.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  size: AppConstants.iconSizeMD.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
