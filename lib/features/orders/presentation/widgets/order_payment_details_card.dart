import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_payment_status_entity.dart';
import '../../domain/entities/payment_method.dart';

/// Card displaying payment method, provider, reference number, and verification status.
/// Matching Figma node 1:1306.
class OrderPaymentDetailsCard extends StatelessWidget {
  final OrderEntity order;
  final OrderPaymentStatusEntity? paymentStatus;

  const OrderPaymentDetailsCard({
    super.key,
    required this.order,
    this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final latestPayment = paymentStatus?.latestPayment;
    final bool isPaid = paymentStatus?.isPaid ?? order.isDelivered;

    final String statusLabel = isPaid ? 'Paid' : 'Pending';
    final Color statusColor = isPaid ? AppColors.success : AppColors.warning;
    final Color statusBg = isPaid
        ? AppColors.success.withValues(alpha: 0.12)
        : AppColors.warning.withValues(alpha: 0.12);

    final String provider =
        latestPayment?.provider ??
        (order.paymentMethod == PaymentMethod.creditCard
            ? 'Credit Card'
            : order.paymentMethod == PaymentMethod.cash
            ? 'Cash on Delivery'
            : 'Payment');

    final String reference = latestPayment != null
        ? 'Ref: #${latestPayment.id}'
        : 'Ref: #PMB-${order.id}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.margin.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: AppConstants.hairlineStrokeWidth,
        ),
        boxShadow: AppConstants.elevationLevel2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Credit card icon + "Payment Details" + Status chip
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
                  Icons.credit_card_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Expanded(
                child: Text(
                  'Payment Details',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                  vertical: AppConstants.spacingXS.h / 1.5,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppConstants.indicatorDotSize.r - 1.r,
                      height: AppConstants.indicatorDotSize.r - 1.r,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: (AppConstants.spacingXS + 1).w),
                    Text(
                      statusLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Provider & Verified Shield
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                provider,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: AppConstants.iconSizeSM.r,
                    color: AppColors.success,
                  ),
                  SizedBox(width: (AppConstants.spacingXS / 1.5).w),
                  Text(
                    'Verified',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingXS.h),

          // Transaction Reference
          Text(
            reference,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
