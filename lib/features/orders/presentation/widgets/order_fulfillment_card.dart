import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';

/// Large fulfillment status card displaying fulfillment status, headline, date, and semantic badge.
/// Matching Figma node 1:1306.
class OrderFulfillmentCard extends StatelessWidget {
  final OrderEntity order;

  const OrderFulfillmentCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isDelivered = order.isDelivered;
    final isCancelled = order.isCancelled;

    final Color statusColor = isDelivered
        ? AppColors.success
        : isCancelled
        ? colorScheme.error
        : AppColors.warning;

    final Color statusBg = isDelivered
        ? AppColors.success.withValues(alpha: 0.12)
        : isCancelled
        ? colorScheme.errorContainer.withValues(alpha: 0.5)
        : AppColors.warning.withValues(alpha: 0.12);

    final IconData statusIcon = isDelivered
        ? Icons.check_circle_rounded
        : isCancelled
        ? Icons.cancel_rounded
        : Icons.access_time_rounded;

    final String statusLabel = isDelivered
        ? 'Delivered'
        : isCancelled
        ? 'Cancelled'
        : order.isProcessing
        ? 'Processing'
        : order.isShipped
        ? 'Shipped'
        : 'Pending';

    final String headline = isDelivered
        ? 'Delivered on ${_formatDate(order.updatedAt)}'
        : isCancelled
        ? 'Order Cancelled'
        : order.isProcessing
        ? 'Order Processing'
        : order.isShipped
        ? 'Order Shipped'
        : 'Order Pending';

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
          // Icon & Overline
          Row(
            children: [
              Container(
                width: AppConstants.avatarSizeSM.r,
                height: AppConstants.avatarSizeSM.r,
                decoration: BoxDecoration(
                  color: statusBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  size: AppConstants.iconSizeSM.r + 2.r,
                  color: statusColor,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Expanded(
                child: Text(
                  'FULFILLMENT STATUS',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              // Semantic status chip
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

          // Headline
          Text(
            headline,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}
