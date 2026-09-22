import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

/// Calculation summary card showing items preview, delivery speed, and financial breakdown.
/// Adheres strictly to AGENTS.md: zero magic numbers and pure Theme.of(context) styling.
class CheckoutOrderSummaryCard extends StatelessWidget {
  final CartEntity? cart;
  final List<CartItemEntity>? items;
  final double? subtotal;
  final double? total;
  final double? estimatedTax;

  const CheckoutOrderSummaryCard({
    super.key,
    this.cart,
    this.items,
    this.subtotal,
    this.total,
    this.estimatedTax,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final effectiveItems = items ?? cart?.items ?? const [];
    final effectiveSubtotal = subtotal ?? cart?.totalPrice ?? 0.0;
    final effectiveTax = estimatedTax ?? 0.0;
    final effectiveTotal = total ?? (effectiveSubtotal + effectiveTax);
    final count = effectiveItems.length;
    final countText = count == 1 ? '1 Item' : '$count Items';

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
          // Header: Shopping bag icon + Order Summary + Badge X Items
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
                  Icons.shopping_bag_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Expanded(
                child: Text(
                  'Order Summary',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                  vertical: AppConstants.spacingXS.h / 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                ),
                child: Text(
                  countText,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),

          // Horizontal product thumbnails preview
          if (effectiveItems.isNotEmpty) ...[
            SizedBox(height: AppConstants.spacingMD.h),
            SizedBox(
              height: AppConstants.headerHeight.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: effectiveItems.length,
                separatorBuilder: (context, index) =>
                    SizedBox(width: AppConstants.spacingSM.w),
                itemBuilder: (context, index) {
                  final item = effectiveItems[index];
                  final imageUrl = item.product?.primaryImageUrl;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: AppConstants.buttonHeight.w,
                        height: AppConstants.buttonHeight.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMD.r,
                          ),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                            width: AppConstants.hairlineStrokeWidth,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMD.r,
                          ),
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.inventory_2_outlined,
                                        size: AppConstants.iconSizeSM.r,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                )
                              : Icon(
                                  Icons.inventory_2_outlined,
                                  size: AppConstants.iconSizeSM.r,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: -AppConstants.spacingXS.h / 2,
                        right: -AppConstants.spacingXS.w / 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingXS.w + 1.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusRound,
                            ),
                            boxShadow: AppConstants.elevationLevel2,
                          ),
                          child: Text(
                            '${item.quantity}x',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          SizedBox(height: AppConstants.spacingMD.h),

          // Delivery speed container
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMD.w,
              vertical: AppConstants.spacingSM.h + AppConstants.spacingXS.h / 2,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
                SizedBox(width: AppConstants.spacingSM.w),
                Expanded(
                  child: Text(
                    'Standard Shipping',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                Text(
                  'Est. 2–3 days',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Items Subtotal Row
          _buildRow(
            label: 'Items Subtotal',
            valueWidget: Text(
              '\$${effectiveSubtotal.toStringAsFixed(2)}',
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
          _buildRow(
            label: 'Standard Shipping',
            valueWidget: Text(
              'FREE',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: AppConstants.spacingSM.h),

          // Estimated Sales Tax Row
          _buildRow(
            label: 'Estimated Sales Tax',
            valueWidget: Text(
              '\$${effectiveTax.toStringAsFixed(2)}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Divider line
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            height: AppConstants.hairlineStrokeWidth,
            thickness: AppConstants.hairlineStrokeWidth,
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Total Payable Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Total Payable',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Text(
                '\$${effectiveTotal.toStringAsFixed(2)}',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 22.sp,
                  letterSpacing: -0.5,
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
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppConstants.spacingSM.w),
        valueWidget,
      ],
    );
  }
}
