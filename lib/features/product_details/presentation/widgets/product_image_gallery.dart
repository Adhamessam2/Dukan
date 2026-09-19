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
    final heroHeight = AppConstants.productHeroHeight.h.clamp(260.0, 420.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingSM.h,
      ),
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                width: double.infinity,
                height: heroHeight,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                    width: AppConstants.hairlineStrokeWidth,
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: colorScheme.surfaceContainer,
                highlightColor: colorScheme.surfaceContainerLow,
                child: Container(
                  width: double.infinity,
                  height: heroHeight,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusLG.r,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                height: heroHeight,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                    width: AppConstants.hairlineStrokeWidth,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.outlineVariant,
                    size: AppConstants.iconSizeXL.r,
                  ),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: heroHeight,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                  width: AppConstants.hairlineStrokeWidth,
                ),
              ),
              child: Center(
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
