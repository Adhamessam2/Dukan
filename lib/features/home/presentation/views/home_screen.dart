import 'package:Dukan/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_craftsmanship_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_products_grid.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_spotlight_banner.dart';

/// The primary Home screen coordinating all sections
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  void _showSortOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<HomeCubit>();
    final currentSort = cubit.state.sortOption;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLG.r),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingMD.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusRound,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.spacingMD.h),
                Text(
                  'Sort Products',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppConstants.spacingSM.h),
                _buildSortTile(
                  ctx: ctx,
                  cubit: cubit,
                  option: ProductSortOption.curated,
                  icon: Icons.auto_awesome_rounded,
                  isSelected: currentSort == ProductSortOption.curated,
                ),
                _buildSortTile(
                  ctx: ctx,
                  cubit: cubit,
                  option: ProductSortOption.priceLowToHigh,
                  icon: Icons.arrow_upward_rounded,
                  isSelected: currentSort == ProductSortOption.priceLowToHigh,
                ),
                _buildSortTile(
                  ctx: ctx,
                  cubit: cubit,
                  option: ProductSortOption.priceHighToLow,
                  icon: Icons.arrow_downward_rounded,
                  isSelected: currentSort == ProductSortOption.priceHighToLow,
                ),
                _buildSortTile(
                  ctx: ctx,
                  cubit: cubit,
                  option: ProductSortOption.topRated,
                  icon: Icons.star_rounded,
                  isSelected: currentSort == ProductSortOption.topRated,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortTile({
    required BuildContext ctx,
    required HomeCubit cubit,
    required ProductSortOption option,
    required IconData icon,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(ctx).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        option.label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_rounded,
              color: colorScheme.primary,
              size: AppConstants.iconSizeSM.r + 4.r,
            )
          : null,
      onTap: () {
        cubit.selectSortOption(option);
        Navigator.pop(ctx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<HomeCubit, HomeState>(
              listenWhen: (previous, current) =>
                  previous.errorMessage != current.errorMessage &&
                  current.errorMessage != null,
              listener: (context, state) {
                if (state.errorMessage != null) {
                  context.showErrorSnackBar(
                    state.errorMessage ?? 'something went wrong',
                  );
                }
              },
            ),
            BlocListener<CartCubit, CartState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == CartStatus.success) {
                  context.showSuccessSnackBar('Added to your bag');
                  context.read<CartCubit>().getCart();
                } else if (state.status == CartStatus.failure &&
                    state.errorMessage != null) {
                  context.showErrorSnackBar(state.errorMessage!);
                }
              },
            ),
          ],
          child: RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            color: colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  const HomeHeader(),

                  // Search Bar
                  HomeSearchBar(
                    onSearchChanged: (query) {
                      context.read<HomeCubit>().updateSearchQuery(query);
                    },
                    onFilterTap: () {
                      // Filter options
                    },
                    onVoiceSearchTap: () {
                      // Voice search
                    },
                  ),

                  SizedBox(height: AppConstants.spacingXS.h),

                  // Horizontal Category Chips
                  const HomeCategoryChips(),

                  SizedBox(height: AppConstants.spacingSM.h),

                  // Editorial Spotlight Banner
                  const HomeSpotlightBanner(),

                  // Featured Products Section Header
                  HomeSectionHeader(onSortTap: () => _showSortOptions(context)),

                  SizedBox(height: AppConstants.spacingSM.h),

                  // 2-Column Responsive Products Grid
                  HomeProductsGrid(
                    onProductTap: (product) {
                      context.push(
                        Routes.productDetailsPath(product.id),
                        extra: product,
                      );
                    },
                    onAddToCart: (product) {
                      if (!product.isInStock) return;
                      context.read<CartCubit>().addToCart(
                        productId: product.id,
                        quantity: 1,
                      );
                    },
                  ),

                  // Craftsmanship Note / Footer Delight
                  const HomeCraftsmanshipCard(),

                  SizedBox(height: AppConstants.spacingLG.h),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocSelector<CartCubit, CartState, int>(
        selector: (state) => state.cart?.items.length ?? 0,
        builder: (context, cartCount) {
          return HomeBottomNavBar(
            selectedIndex: _navIndex,
            cartItemCount: cartCount,
            onIndexChanged: (index) {
              if (index == 2) {
                context.push(Routes.cart);
              } else if (index == 3) {
                context.push(Routes.orders);
              } else {
                setState(() => _navIndex = index);
              }
            },
          );
        },
      ),
    );
  }
}
