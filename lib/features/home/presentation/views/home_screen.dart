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
                  const HomeSectionHeader(),

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
