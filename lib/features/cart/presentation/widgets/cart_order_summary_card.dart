import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Calculation summary card showing subtotal, shipping, tax, and total amount
/// matching Figma #1:575 specifications.
class CartOrderSummaryCard extends StatelessWidget {
  final double totalPrice;

  const CartOrderSummaryCard({super.key, required this.totalPrice});

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
          // Header
          Text(
            'Order Summary',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Subtotal Row
          _buildRow(
            label: 'Subtotal',
            valueWidget: Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Standard Shipping Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Standard Shipping',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppConstants.spacingXS.w),
                    Icon(
                      Icons.info_outline_rounded,
                      size: AppConstants.iconSizeSM.r - 2.r,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppConstants.spacingXS.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$12.00',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingXS.w + 2.w),
                  Text(
                    'FREE',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Estimated Tax Row
          _buildRow(
            label: 'Estimated Tax',
            valueWidget: Text(
              'Included',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Divider
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            height: AppConstants.hairlineStrokeWidth,
            thickness: AppConstants.hairlineStrokeWidth,
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Total Amount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: AppConstants.spacingXS.h / 2),
                    Text(
                      'Includes local sales tax',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 24.sp,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required Widget valueWidget,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        valueWidget,
      ],
    );
  }
}
