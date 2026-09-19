import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/domain/entities/product_entity.dart';

/// Information section displaying product title, category breadcrumb, rating, price, SKU, and formatted description
class ProductInfoSection extends StatelessWidget {
  final ProductEntity product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final category = product.category;
    final parentCategoryName = category?.parent?.categoryName;
    final categoryName = category?.categoryName;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppConstants.spacingMD.h),

          // Category Breadcrumb
          if (categoryName != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppConstants.spacingXS.h),
              child: Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.secondary,
                  ),
                  SizedBox(width: AppConstants.spacingXS.w),
                  Expanded(
                    child: Text(
                      parentCategoryName != null
                          ? '$parentCategoryName > $categoryName'
                          : categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Product Name
          Text(
            product.productName,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: AppConstants.spacingSM.h),

          // Rating, Reviews & SKU Row
          Wrap(
            spacing: AppConstants.spacingSM.w,
            runSpacing: AppConstants.spacingXS.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Rating Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSM.w,
                  vertical: AppConstants.spacingXS.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusDefault,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: AppConstants.iconSizeSM.r,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: AppConstants.spacingXS.w),
                    Text(
                      product.avgRating.toStringAsFixed(1),
                      style:
                          (textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ) ??
                                  const TextStyle())
                              .withTabularFigures(),
                    ),
                    SizedBox(width: AppConstants.spacingXS.w),
                    Text(
                      '(${product.totalReviews} reviews)',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // SKU Chip with Copy action
              if (product.sku != null && product.sku!.isNotEmpty)
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: product.sku!));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('SKU ${product.sku} copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusDefault,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSM.w,
                      vertical: AppConstants.spacingXS.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                        width: AppConstants.hairlineStrokeWidth,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusDefault,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'SKU: ${product.sku}',
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: AppConstants.spacingXS.w),
                        Icon(
                          Icons.copy_rounded,
                          size: AppConstants.iconSizeSM.r - 2.r,
                          color: colorScheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: AppConstants.spacingMD.h),

          // Price & Stock Status Box
          Container(
            padding: EdgeInsets.all(AppConstants.spacingMD.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        overflow: TextOverflow.ellipsis,
                        style:
                            (textTheme.headlineMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ) ??
                                    const TextStyle())
                                .withTabularFigures(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppConstants.spacingSM.w),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.gutter.w,
                      vertical: AppConstants.spacingXS.h + 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: product.isInStock
                          ? colorScheme.primaryContainer.withValues(alpha: 0.4)
                          : colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusRound,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product.isInStock
                              ? Icons.check_circle_outline_rounded
                              : Icons.highlight_off_rounded,
                          size: AppConstants.iconSizeSM.r,
                          color: product.isInStock
                              ? colorScheme.primary
                              : colorScheme.error,
                        ),
                        SizedBox(width: AppConstants.spacingXS.w + 2.w),
                        Flexible(
                          child: Text(
                            product.isInStock
                                ? 'In Stock (${product.stockQuantity} left)'
                                : 'Out of Stock',
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelMedium?.copyWith(
                              color: product.isInStock
                                  ? colorScheme.primary
                                  : colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppConstants.spacingLG.h),

          // Description Header
          Text(
            'Description',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppConstants.spacingSM.h),

          // Formatted Description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppConstants.spacingMD.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            child: _buildFormattedDescription(
              context,
              product.productDescription,
            ),
          ),

          SizedBox(height: AppConstants.spacingLG.h),
        ],
      ),
    );
  }

  /// Parses simple HTML formatting like <b>...</b> and newlines cleanly into RichText
  Widget _buildFormattedDescription(BuildContext context, String? description) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (description == null || description.trim().isEmpty) {
      return Text(
        'No description provided for this product.',
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.secondary,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final normalized = description.replaceAll(r'\n', '\n');
    final matches = AppConstants.htmlBoldRegex.allMatches(normalized);
    final spans = <TextSpan>[];

    for (final match in matches) {
      final boldText = match.group(1);
      final normalText = match.group(2);

      if (boldText != null) {
        spans.add(
          TextSpan(
            text: boldText,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        );
      } else if (normalText != null) {
        spans.add(
          TextSpan(
            text: normalText,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
          height: 1.5,
          letterSpacing: 0.1,
        ),
        children: spans.isNotEmpty
            ? spans
            : [
                TextSpan(
                  text: normalized,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
      ),
    );
  }
}
