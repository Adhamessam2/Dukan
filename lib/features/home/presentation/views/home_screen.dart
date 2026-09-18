import 'package:Dukan/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
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
                ListTile(
                  leading: const Icon(Icons.auto_awesome_rounded),
                  title: const Text('Curated'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward_rounded),
                  title: const Text('Price: Low to High'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward_rounded),
                  title: const Text('Price: High to Low'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.star_rounded),
                  title: const Text('Top Rated'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            if (state.errorMessage != null) {
              context.showErrorSnackBar(
                state.errorMessage ?? 'somthing went wrong',
              );
            }
          },
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
                  HomeSectionHeader(
                    onSortTap: () => _showSortOptions(context),
                  ),

                  SizedBox(height: AppConstants.spacingSM.h),

                  // 2-Column Responsive Products Grid
                  HomeProductsGrid(
                    onAddToCart: (product) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added ${product.productName} to your bag',
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
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
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _navIndex,
        onIndexChanged: (index) => setState(() => _navIndex = index),
      ),
    );
  }
}
