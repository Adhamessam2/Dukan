import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';

/// Header widget displaying order reference (#DK-id) with bullet and invoice download button.
/// Matching Figma node 1:1306.
class OrderDetailsHeader extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onInvoicePressed;

  const OrderDetailsHeader({
    super.key,
    required this.order,
    this.onInvoicePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Status bullet + Order ID
        Expanded(
          child: Row(
            children: [
              Container(
                width: AppConstants.indicatorDotSize.r,
                height: AppConstants.indicatorDotSize.r,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Flexible(
                child: Text(
                  '#DK-${order.id}',
                  style: textTheme.titleLarge
                      ?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      )
                      .withTabularFigures(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppConstants.spacingSM.w),

        // Invoice pill button
        Material(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          child: InkWell(
            onTap: onInvoicePressed,
            borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMD.w,
                vertical: AppConstants.spacingXS.h,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download_rounded,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.onSurface,
                  ),
                  SizedBox(width: AppConstants.spacingXS.w),
                  Text(
                    'Invoice',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
