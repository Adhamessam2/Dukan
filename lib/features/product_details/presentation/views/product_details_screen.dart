import 'package:Dukan/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';
import '../widgets/product_details_bottom_bar.dart';
import '../widgets/product_details_header.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';

/// Product details screen displaying media gallery, specs, price, and sticky action tray
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            const RepaintBoundary(child: ProductDetailsHeader()),

            // Screen Content
            Expanded(
              child: BlocListener<ProductDetailsCubit, ProductDetailsState>(
                listenWhen: (prev, curr) =>
                    prev.errorMessage != curr.errorMessage &&
                    curr.errorMessage != null,
                listener: (context, state) {
                  if (state.errorMessage != null) {
                    context.showErrorSnackBar(state.errorMessage!);
                  }
                },
                child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                  buildWhen: (prev, curr) =>
                      prev.status != curr.status ||
                      prev.product != curr.product,
                  builder: (context, state) {
                    if (state.status == ProductDetailsStatus.loading &&
                        state.product == null) {
                      return _buildLoadingShimmer(context);
                    }

                    if (state.status == ProductDetailsStatus.failure &&
                        state.product == null) {
                      return _buildErrorState(context, state.errorMessage);
                    }

                    final product = state.product;
                    if (product == null) {
                      return const SizedBox.shrink();
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rounded Product Hero Image
                          RepaintBoundary(
                            child: ProductImageGallery(
                              imageUrl: product.primaryImageUrl,
                            ),
                          ),

                          // Information Section
                          ProductInfoSection(product: product),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BlocSelector<
            ProductDetailsCubit,
            ProductDetailsState,
            (ProductEntity?, int, double)
          >(
            selector: (state) =>
                (state.product, state.quantity, state.totalPrice),
            builder: (context, data) {
              final (product, quantity, totalPrice) = data;
              if (product == null) return const SizedBox.shrink();

              return ProductDetailsBottomBar(
                quantity: quantity,
                maxStock: product.stockQuantity,
                totalPrice: totalPrice,
                isInStock: product.isInStock,
                onIncrement: () =>
                    context.read<ProductDetailsCubit>().incrementQuantity(),
                onDecrement: () =>
                    context.read<ProductDetailsCubit>().decrementQuantity(),
                onAddToCart: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added $quantity x ${product.productName} to your bag',
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainer,
      highlightColor: colorScheme.surfaceContainerLow,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.margin.w,
                vertical: AppConstants.spacingSM.h,
              ),
              child: Container(
                width: double.infinity,
                height: AppConstants.productHeroHeight.h.clamp(260.0, 420.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
                ),
              ),
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusDefault.r,
                      ),
                    ),
                  ),
                  SizedBox(height: AppConstants.spacingSM.h),
                  Container(
                    width: double.infinity,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusDefault.r,
                      ),
                    ),
                  ),
                  SizedBox(height: AppConstants.spacingMD.h),
                  Container(
                    width: double.infinity,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusLG.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.spacingLG.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: AppConstants.iconSizeXL.r,
              color: colorScheme.error,
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            Text(
              message ?? 'Failed to load product details',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppConstants.spacingMD.h),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
