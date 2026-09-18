import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants.dart';

/// Single product hero image card with rounded borders and shimmer placeholder
class ProductImageGallery extends StatelessWidget {
  final String? imageUrl;

  const ProductImageGallery({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingSM.h,
      ),
      child: Container(
        width: double.infinity,
        height: AppConstants.productHeroHeight.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: colorScheme.surfaceContainer,
                  highlightColor: colorScheme.surfaceContainerLow,
                  child: Container(color: colorScheme.surfaceContainer),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.outlineVariant,
                    size: AppConstants.iconSizeXL.r,
                  ),
                ),
              )
            : Center(
                child: Icon(
                  Icons.image_outlined,
                  color: colorScheme.outlineVariant,
                  size: AppConstants.avatarSizeLG.r,
                ),
              ),
      ),
    );
  }
}
