import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';

/// Calculation summary card showing subtotal, free shipping promo, estimated tax,
/// and total paid with disclaimer.
/// Matching Figma node 1:1306.
class OrderDetailsSummaryCard extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
          // Header: Order Summary
          Text(
            'Order Summary',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Subtotal Row
          _buildRow(
            context,
            label: 'Subtotal',
            valueWidget: Text(
              '\$${order.totalAmount.toStringAsFixed(2)}',
              style: textTheme.bodyMedium
                  ?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  )
                  .withTabularFigures(),
            ),
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Standard Shipping Row
          _buildRow(
            context,
            label: 'Standard Shipping',
            valueWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FREE',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (AppConstants.spacingXS + 2).w,
                    vertical: (AppConstants.spacingXS / 2).h,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusRound,
                    ),
                  ),
                  child: Text(
                    'Promo',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Estimated Tax Row
          _buildRow(
            context,
            label: 'Estimated Tax',
            valueWidget: Text(
              '\$0.00',
              style: textTheme.bodyMedium
                  ?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  )
                  .withTabularFigures(),
            ),
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Divider
          Divider(
            height: AppConstants.hairlineStrokeWidth,
            thickness: AppConstants.hairlineStrokeWidth,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Total Paid Row with subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Paid',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: (AppConstants.spacingXS / 2).h),
                    Text(
                      'Includes all taxes & delivery fees',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: textTheme.headlineSmall
                    ?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    )
                    .withTabularFigures(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required Widget valueWidget,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
