import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Product item card in the Cart screen matching Figma #1:493 specifications.
class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final product = item.product;
    final price = product?.price ?? 0.0;
    final totalPrice = price * item.quantity;
    final imageUrl = product?.primaryImageUrl;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Product Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
            child: Container(
              width: AppConstants.cartImageWidth.w,
              height: AppConstants.cartImageHeight.h,
              color: colorScheme.surfaceContainer,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Center(
                        child: SizedBox(
                          width: AppConstants.controlSize.r,
                          height: AppConstants.controlSize.r,
                          child: CircularProgressIndicator(
                            strokeWidth: AppConstants.hairlineStrokeWidth * 2,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (_, _, _) => _buildPlaceholder(colorScheme),
                    )
                  : _buildPlaceholder(colorScheme),
            ),
          ),
          SizedBox(width: AppConstants.margin.w),

          // Right Content Area
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: AppConstants.cartImageHeight.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Title & Remove Action Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product?.productName.trim() ?? 'Product',
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppConstants.spacingXS.h),
                            Text(
                              '\$${price.toStringAsFixed(2)} each',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusRound,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppConstants.spacingXS.r),
                          child: Icon(
                            Icons.close_rounded,
                            size: AppConstants.iconSizeSM.r,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.spacingSM.h),

                  // Bottom Stepper & Total Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Stepper Capsule
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingSM.w,
                          vertical: AppConstants.spacingXS.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusRound,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement
                            InkWell(
                              onTap: onDecrement,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusRound,
                              ),
                              child: Container(
                                width: AppConstants.stepperButtonSize.r,
                                height: AppConstants.stepperButtonSize.r,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.remove_rounded,
                                    size: AppConstants.iconSizeSM.r,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingSM.w,
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            // Increment
                            InkWell(
                              onTap: onIncrement,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusRound,
                              ),
                              child: Container(
                                width: AppConstants.stepperButtonSize.r,
                                height: AppConstants.stepperButtonSize.r,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_rounded,
                                    size: AppConstants.iconSizeSM.r,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Item Total Price
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        size: AppConstants.iconSizeLG.r,
        color: colorScheme.outlineVariant,
      ),
    );
  }
}
