import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../domain/entities/product_entity.dart';

/// Product card adhering to the 2-column Figma specifications
class HomeProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const HomeProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = product.primaryImageUrl ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
          boxShadow: AppConstants.elevationLevel2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4:5 Media Aspect Image Box
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: colorScheme.surfaceContainerLow,
                      child: Opacity(
                        opacity: product.isInStock ? 1.0 : 0.65,
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: colorScheme.surfaceContainer,
                                      highlightColor:
                                          colorScheme.surfaceContainerLow,
                                      child: Container(
                                        color: colorScheme.surfaceContainer,
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: colorScheme.outlineVariant,
                                    size: 32.r,
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  color: colorScheme.outlineVariant,
                                  size: 32.r,
                                ),
                              ),
                      ),
                    ),

                    // Top-Left Badge: OUT OF STOCK takes precedence over rating
                    if (!product.isInStock)
                      Positioned(
                        top: AppConstants.spacingSM.h,
                        left: AppConstants.spacingSM.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSM.w,
                            vertical: (AppConstants.spacingXS / 2).h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusRound,
                            ),
                          ),
                          child: Text(
                            'OUT OF STOCK',
                            style: TextStyle(
                              color: colorScheme.onError,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )
                    else if (product.avgRating >= 4.5)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryFixed.withValues(
                              alpha: 0.95,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusRound,
                            ),
                          ),
                          child: Text(
                            product.avgRating >= 5.0 ? 'BEST' : 'TOP RATED',
                            style: TextStyle(
                              color: colorScheme.onPrimaryFixed,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // Category Subtitle
            Text(
              product.category?.categoryName ?? 'Essential',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            // Product Title
            Text(
              product.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),

            SizedBox(height: 6.h),

            // Price & Add Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                BlocSelector<
                  CartCubit,
                  CartState,
                  ({bool isAddingThis, bool isAnyLoading})
                >(
                  selector: (state) => (
                    isAddingThis:
                        state.addingProductId == product.id &&
                        state.status == CartStatus.loading,
                    isAnyLoading: state.status == CartStatus.loading,
                  ),
                  builder: (context, addState) {
                    final bool canAddToCart =
                        product.isInStock && !addState.isAnyLoading;

                    return InkWell(
                      onTap: canAddToCart
                          ? (onAddToCart ??
                                () => context.read<CartCubit>().addToCart(
                                  productId: product.id,
                                  quantity: 1,
                                ))
                          : null,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusRound,
                      ),
                      child: Container(
                        width: 32.r,
                        height: 32.r,
                        decoration: BoxDecoration(
                          color: product.isInStock
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          boxShadow: product.isInStock
                              ? AppConstants.elevationLevel2
                              : null,
                        ),
                        child: Center(
                          child: addState.isAddingThis
                              ? SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : Icon(
                                  product.isInStock
                                      ? Icons.add_rounded
                                      : Icons.remove_shopping_cart_outlined,
                                  color: product.isInStock
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurfaceVariant.withValues(
                                          alpha: 0.38,
                                        ),
                                  size: 18.r,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
