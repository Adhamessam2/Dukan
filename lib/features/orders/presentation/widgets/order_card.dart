import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';

/// Order card displaying order reference, status chip, item thumbnails, total price,
/// and "View Details →" CTA matching Figma node 1:1090.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final ValueChanged<OrderEntity> onViewDetails;

  const OrderCard({
    super.key,
    required this.order,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: AppConstants.hairlineStrokeWidth,
        ),
        boxShadow: AppConstants.elevationLevel2,
      ),
      padding: EdgeInsets.all(AppConstants.margin.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: #DK-ID • Date + Status Chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '#DK-${order.id}',
                      style: textTheme.titleMedium
                          ?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          )
                          .withTabularFigures(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingXS.w,
                      ),
                      child: Text(
                        '•',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        _formatDate(order.createdAt),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              _buildStatusChip(context),
            ],
          ),
          SizedBox(height: (AppConstants.spacingXS / 1.5).h),

          // Subtitle / Item description
          Text(
            _buildOrderSubtitle(order),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Thumbnails & Details Area
          _buildThumbnailsSection(context),
          SizedBox(height: AppConstants.spacingSM.h),

          // Divider
          Divider(
            height: AppConstants.hairlineStrokeWidth,
            thickness: AppConstants.hairlineStrokeWidth,
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Footer: Total Amount & View Details CTA
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
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: textTheme.titleLarge
                          ?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                          )
                          .withTabularFigures(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              _buildViewDetailsButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool isDelivered = order.isDelivered;
    final bool isCancelled = order.isCancelled;

    final Color dotColor = isDelivered
        ? AppColors.success
        : isCancelled
        ? colorScheme.error
        : AppColors.warning;

    final Color chipBg = isDelivered
        ? AppColors.success.withValues(alpha: 0.12)
        : isCancelled
        ? colorScheme.errorContainer.withValues(alpha: 0.5)
        : AppColors.warning.withValues(alpha: 0.12);

    final String label = isDelivered
        ? 'Delivered'
        : isCancelled
        ? 'Cancelled'
        : 'In Progress';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (AppConstants.spacingXS + 2.0).w,
        vertical: (AppConstants.spacingXS / 2).h,
      ),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppConstants.indicatorDotSize.r,
            height: AppConstants.indicatorDotSize.r,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: AppConstants.spacingXS.w),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: dotColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (order.items.isEmpty) {
      return Container(
        height: AppConstants.avatarSizeLG.h,
        alignment: Alignment.centerLeft,
        child: Text(
          'Shipping to: ${order.shippingCity}, ${order.shippingStreet}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    if (order.items.length == 1) {
      final item = order.items.first;
      return Row(
        children: [
          _buildThumbnailImage(context, item.product.primaryImageUrl),
          SizedBox(width: AppConstants.spacingSM.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item.quantity} item',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.product.productName,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Multiple items
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: order.items.take(3).map((item) {
                return Padding(
                  padding: EdgeInsets.only(right: AppConstants.spacingSM.w),
                  child: _buildThumbnailImage(
                    context,
                    item.product.primaryImageUrl,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: AppConstants.spacingSM.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              order.isDelivered ? 'Delivered to Address' : 'Shipping to',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              order.shippingCity,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThumbnailImage(BuildContext context, String? imageUrl) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: AppConstants.avatarSizeLG.r,
      height: AppConstants.avatarSizeLG.r,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: AppConstants.hairlineStrokeWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _buildFallbackThumbnail(context),
            )
          : _buildFallbackThumbnail(context),
    );
  }

  Widget _buildFallbackThumbnail(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: AppConstants.iconSizeMD.r,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
      child: InkWell(
        onTap: () => onViewDetails(order),
        borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (AppConstants.spacingSM + 2.0).w,
            vertical: (AppConstants.spacingXS + 2.0).h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View Details',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: (AppConstants.spacingXS / 1.5).w),
              Icon(
                Icons.arrow_forward_rounded,
                size: AppConstants.iconSizeSM.r - 2.r,
                color: colorScheme.onSurface,
              ),
            ],
          ),
        ),
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

  String _buildOrderSubtitle(OrderEntity order) {
    if (order.items.isEmpty) return 'No items listed';
    final firstItem = order.items.first;
    if (order.items.length == 1) {
      return firstItem.product.productName;
    }
    final remainingCount = order.items.length - 1;
    return '${order.items.length} items • ${firstItem.product.productName} + $remainingCount more';
  }
}
