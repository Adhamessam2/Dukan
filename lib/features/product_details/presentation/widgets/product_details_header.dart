import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Top header bar for Product Details screen displaying brand logo and screen title
class ProductDetailsHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const ProductDetailsHeader({
    super.key,
    this.title = 'Product Details',
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      height: AppConstants.headerHeight.h.clamp(56.0, 72.0),
      padding: EdgeInsets.symmetric(
        horizontal: showBackButton
            ? AppConstants.spacingXS.w
            : AppConstants.margin.w,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button (when enabled)
          if (showBackButton)
            IconButton(
              onPressed: onBackTap ?? () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colorScheme.onSurface,
                size: AppConstants.iconSizeSM.r,
              ),
              tooltip: 'Back',
            ),

          // Brand Logo ('D' monogram)
          RepaintBoundary(
            child: Container(
              width: AppConstants.avatarSizeSM.r,
              height: AppConstants.avatarSizeSM.r,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'D',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppConstants.spacingSM.w),

          // Screen Title
          Expanded(
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
