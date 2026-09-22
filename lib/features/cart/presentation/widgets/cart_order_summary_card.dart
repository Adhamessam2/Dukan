import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';

/// Calculation summary card showing subtotal, shipping, tax, and total amount
/// matching Figma #1:575 specifications.
/// Supports a compact presentation mode for constrained landscape right columns.
class CartOrderSummaryCard extends StatelessWidget {
  final double totalPrice;
  final bool isCompact;

  const CartOrderSummaryCard({
    super.key,
    required this.totalPrice,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(
        isCompact ? AppConstants.spacingSM.r : AppConstants.margin.r,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          isCompact ? AppConstants.radiusMD.r : AppConstants.radiusLG.r,
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: AppConstants.hairlineStrokeWidth,
        ),
        boxShadow: AppConstants.elevationLevel2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            'Order Summary',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: isCompact ? 13.sp : 16.sp,
            ),
          ),
          SizedBox(
            height: isCompact
                ? AppConstants.spacingXS.h
                : AppConstants.spacingMD.h,
          ),

          // Subtotal Row
          _buildRow(
            label: 'Subtotal',
            valueWidget: Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: (isCompact ? textTheme.bodySmall : textTheme.bodyMedium)
                  ?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 12.sp : null,
                  )
                  .withTabularFigures(),
            ),
            colorScheme: colorScheme,
            textTheme: textTheme,
            isCompact: isCompact,
          ),
          SizedBox(
            height: isCompact
                ? (AppConstants.spacingXS / 2).h
                : AppConstants.spacingSM.h,
          ),

          if (isCompact) ...[
            // Compact Shipping & Tax line with tooltip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Shipping & Tax',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: AppConstants.spacingXS.w),
                      Tooltip(
                        message: 'Standard Shipping FREE • Sales tax included',
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: AppConstants.iconSizeSM.r,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                Text(
                  'FREE • Incl.',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ] else ...[
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
              isCompact: false,
            ),
          ],
          SizedBox(
            height: isCompact
                ? AppConstants.spacingXS.h
                : AppConstants.spacingMD.h,
          ),

          // Divider
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            height: AppConstants.hairlineStrokeWidth,
            thickness: AppConstants.hairlineStrokeWidth,
          ),
          SizedBox(
            height: isCompact
                ? AppConstants.spacingXS.h
                : AppConstants.spacingMD.h,
          ),

          // Total Amount Row
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
                      'Total Amount',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: isCompact ? 13.sp : 16.sp,
                      ),
                    ),
                    if (!isCompact) ...[
                      SizedBox(height: AppConstants.spacingXS.h / 2),
                      Text(
                        'Includes local sales tax',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style:
                        (isCompact
                                ? textTheme.titleMedium
                                : textTheme.headlineSmall)
                            ?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: isCompact ? 16.sp : 24.sp,
                              letterSpacing: -0.5,
                            )
                            .withTabularFigures(),
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
    required bool isCompact,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: (isCompact ? textTheme.bodySmall : textTheme.bodyMedium)
                ?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: isCompact ? 12.sp : null,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppConstants.spacingXS.w),
        valueWidget,
      ],
    );
  }
}
