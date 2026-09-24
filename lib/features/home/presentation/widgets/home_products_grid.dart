import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_product_card.dart';

/// 2-Column responsive grid for displaying products
class HomeProductsGrid extends StatelessWidget {
  final ValueChanged<ProductEntity>? onProductTap;
  final ValueChanged<ProductEntity>? onAddToCart;

  const HomeProductsGrid({super.key, this.onProductTap, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocSelector<
      HomeCubit,
      HomeState,
      (List<ProductEntity>, HomeStatus, String?)
    >(
      selector: (state) =>
          (state.filteredProducts, state.productsStatus, state.errorMessage),
      builder: (context, data) {
        final (products, status, errorMessage) = data;

        if (status == HomeStatus.loading && products.isEmpty) {
          return _buildLoadingShimmer(colorScheme);
        }

        if (status == HomeStatus.failure && products.isEmpty) {
          return _buildErrorView(context, colorScheme, errorMessage);
        }

        if (products.isEmpty) {
          return _buildEmptyView(colorScheme);
        }

        final isLandscape =
            MediaQuery.orientationOf(context) == Orientation.landscape;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isLandscape ? 4 : 2,
              mainAxisSpacing: AppConstants.gutter.h,
              crossAxisSpacing: AppConstants.gutter.w,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return HomeProductCard(
                product: product,
                onTap: () => onProductTap?.call(product),
                onAddToCart: () => onAddToCart?.call(product),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainer,
        highlightColor: colorScheme.surfaceContainerLow,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppConstants.gutter.h,
            crossAxisSpacing: AppConstants.gutter.w,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    ColorScheme colorScheme,
    String? message,
  ) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.spacingLG.r),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: AppConstants.avatarSizeMD.r,
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            Text(
              message ?? 'Failed to load products',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14.sp),
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            TextButton.icon(
              onPressed: () => context.read<HomeCubit>().loadHomeData(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.spacingXL.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: colorScheme.outlineVariant,
              size: AppConstants.avatarSizeLG.r,
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            Text(
              'No products found',
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
