import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_item_entity.dart';

/// Card listing all items in the order with count pill, product thumbnail,
/// title, qty, status pill, total item price, and "Buy Again" button.
/// Matching Figma node 1:1306.
class OrderItemsCard extends StatelessWidget {
  final OrderEntity order;
  final ValueChanged<OrderItemEntity> onBuyAgain;

  const OrderItemsCard({
    super.key,
    required this.order,
    required this.onBuyAgain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final itemCount = order.items.length;
    final itemCountText = itemCount == 1 ? '1 item' : '$itemCount items';

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
          // Header: Items in Order + Count badge pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items in Order',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                  vertical: AppConstants.spacingXS.h / 1.5,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                ),
                child: Text(
                  itemCountText,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: AppConstants.spacingSM.h),
              child: Divider(
                height: AppConstants.hairlineStrokeWidth,
                thickness: AppConstants.hairlineStrokeWidth,
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return _buildItemRow(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, OrderItemEntity item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isDelivered = order.isDelivered;
    final statusText = isDelivered ? 'Verified Delivery' : 'Pending Delivery';
    final statusColor = isDelivered ? AppColors.success : AppColors.warning;
    final statusBg = isDelivered
        ? AppColors.success.withValues(alpha: 0.12)
        : AppColors.warning.withValues(alpha: 0.12);

    final itemTotalPrice = item.quantity * item.product.price;

    return RepaintBoundary(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
        Container(
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
          child:
              item.product.primaryImageUrl != null &&
                  item.product.primaryImageUrl!.isNotEmpty
              ? Image.network(
                  item.product.primaryImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildFallbackThumbnail(context),
                )
              : _buildFallbackThumbnail(context),
        ),
        SizedBox(width: AppConstants.spacingMD.w),

        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.product.productName,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: (AppConstants.spacingXS / 1.5).h),
              Row(
                children: [
                  Text(
                    'Qty: ${item.quantity}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingSM.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (AppConstants.spacingXS + 2).w,
                      vertical: (AppConstants.spacingXS / 2).h,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusRound,
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.spacingSM.h),

              // Price + Buy Again Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\$${itemTotalPrice.toStringAsFixed(2)}',
                    style: textTheme.titleSmall
                        ?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        )
                        .withTabularFigures(),
                  ),
                  Material(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.6,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusRound,
                    ),
                    child: InkWell(
                      onTap: () => onBuyAgain(item),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusRound,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingMD.w,
                          vertical: (AppConstants.spacingXS + 1).h,
                        ),
                        child: Text(
                          'Buy Again',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
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
}
