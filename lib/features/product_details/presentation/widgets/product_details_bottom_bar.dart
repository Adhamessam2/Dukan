import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';

/// Floating bottom action bar with quantity stepper and primary Add to Bag button
class ProductDetailsBottomBar extends StatelessWidget {
  final int quantity;
  final int maxStock;
  final double totalPrice;
  final bool isInStock;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onAddToCart;

  const ProductDetailsBottomBar({
    super.key,
    required this.quantity,
    required this.maxStock,
    required this.totalPrice,
    required this.isInStock,
    this.onIncrement,
    this.onDecrement,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.gutter.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        boxShadow: AppConstants.elevationLevel3,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quantity Stepper
            Container(
              height: AppConstants.buttonHeight.h,
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
                  IconButton(
                    onPressed: quantity > 1 ? onDecrement : null,
                    icon: Icon(
                      Icons.remove_rounded,
                      size: AppConstants.iconSizeSM.r + 2.r,
                      color: quantity > 1
                          ? colorScheme.onSurface
                          : colorScheme.outlineVariant,
                    ),
                    splashRadius: AppConstants.iconSizeSM.r + 2.r,
                  ),
                  Text(
                    '$quantity',
                    style: (textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ) ??
                            const TextStyle())
                        .withTabularFigures(),
                  ),
                  IconButton(
                    onPressed: quantity < maxStock ? onIncrement : null,
                    icon: Icon(
                      Icons.add_rounded,
                      size: AppConstants.iconSizeSM.r + 2.r,
                      color: quantity < maxStock
                          ? colorScheme.onSurface
                          : colorScheme.outlineVariant,
                    ),
                    splashRadius: AppConstants.iconSizeSM.r + 2.r,
                  ),
                ],
              ),
            ),

            SizedBox(width: AppConstants.spacingSM.w),

            // Primary Add to Bag CTA
            Expanded(
              child: SizedBox(
                height: AppConstants.buttonHeight.h,
                child: FilledButton.icon(
                  onPressed: isInStock ? onAddToCart : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    disabledBackgroundColor: colorScheme.surfaceContainerHigh,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMD.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.margin.w,
                    ),
                  ),
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    size: AppConstants.controlSize.r,
                    color: isInStock
                        ? colorScheme.onPrimary
                        : colorScheme.outlineVariant,
                  ),
                  label: Text(
                    isInStock
                        ? 'Add to Bag • \$${totalPrice.toStringAsFixed(2)}'
                        : 'Out of Stock',
                    style: (textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              color: isInStock
                                  ? colorScheme.onPrimary
                                  : colorScheme.outlineVariant,
                            ) ??
                            const TextStyle())
                        .withTabularFigures(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
