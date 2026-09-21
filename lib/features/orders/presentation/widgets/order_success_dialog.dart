import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/order_entity.dart';

/// Modal dialog presented when order checkout finishes successfully.
/// Conforms strictly to AGENTS.md: pure theme tokens, AppConstants sizing, responsive scroll safety.
class OrderSuccessDialog extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onContinueShopping;
  final VoidCallback? onTrackOrders;

  const OrderSuccessDialog({
    super.key,
    required this.order,
    this.onContinueShopping,
    this.onTrackOrders,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingMD.h,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppConstants.designSizePortrait.width.w,
        ),
        padding: EdgeInsets.all(AppConstants.spacingMD.r),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusXL.r),
          boxShadow: AppConstants.elevationLevel4,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Checkmark Circle
              Container(
                width: AppConstants.avatarSizeMD.r,
                height: AppConstants.avatarSizeMD.r,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: AppConstants.iconSizeLG.r,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: AppConstants.spacingSM.h),

              // Title
              Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: AppConstants.spacingXS.h),

              // Subtitle
              Text(
                'Thank you for your purchase! We are preparing your order.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: AppConstants.spacingMD.h),

              // Order Summary Card
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
                child: Column(
                  children: [
                    _buildInfoRow(
                      label: 'Order ID',
                      value: '#${order.id}',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    SizedBox(height: AppConstants.spacingSM.h),
                    _buildInfoRow(
                      label: 'Total Amount',
                      value: '\$${order.totalAmount.toStringAsFixed(2)}',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      isBold: true,
                    ),
                    SizedBox(height: AppConstants.spacingSM.h),
                    _buildInfoRow(
                      label: 'Estimated Delivery',
                      value: '2–3 business days',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.spacingMD.h),

              // Action buttons: Track Orders & Continue Shopping
              CustomButton(text: 'Track Orders', onPressed: onTrackOrders),
              SizedBox(height: AppConstants.spacingSM.h),
              CustomButton(
                text: 'Continue Shopping',
                onPressed: onContinueShopping,
                variant: CustomButtonVariant.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppConstants.spacingSM.w),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: isBold ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
