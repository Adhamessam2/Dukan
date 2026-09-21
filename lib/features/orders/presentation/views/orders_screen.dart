import 'package:Dukan/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_activity_header.dart';
import '../widgets/orders_empty_view.dart';
import '../widgets/orders_filter_tab_bar.dart';
import '../widgets/orders_search_bar.dart';

/// My Orders / Order History screen matching Figma node 1:1090.
/// Displays order history with search, status filtering, active shipment counter,
/// and adaptive landscape dual-pane layout.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  void _onViewDetails(BuildContext context, OrderEntity order) {
    context.push(Routes.orderDetailsPath(order.id), extra: order);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: BlocListener<OrdersCubit, OrdersState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              curr.status == OrdersStatus.failure &&
              curr.errorMessage != null,
          listener: (context, state) {
            context.showErrorSnackBar(
              state.errorMessage ?? AppConstants.genericErrorMessage,
            );
          },
          child: isLandscape
              ? _buildLandscapeLayout(context)
              : _buildPortraitLayout(context),
        ),
      ),
      bottomNavigationBar: BlocSelector<CartCubit, CartState, int>(
        selector: (state) => state.cart?.items.length ?? 0,
        builder: (context, cartCount) {
          return HomeBottomNavBar(
            selectedIndex: 3,
            cartItemCount: cartCount,
            onIndexChanged: (index) {
              if (index == 0) {
                context.go(Routes.home);
              } else if (index == 2) {
                context.push(Routes.cart);
              }
            },
          );
        },
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CustomAppBar(
      title: 'Dukaan',
      subtitle: 'Order History',
      showBackButton: false,
      leading: RepaintBoundary(
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
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none_rounded,
            color: colorScheme.onSurface,
            size: AppConstants.iconSizeMD.r,
          ),
          splashRadius: 22.r,
        ),
        Padding(
          padding: EdgeInsets.only(right: AppConstants.spacingSM.w),
          child: Container(
            width: AppConstants.avatarSizeSM.r,
            height: AppConstants.avatarSizeSM.r,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: AppConstants.iconSizeSM.r,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<OrdersCubit>();

    return RefreshIndicator(
      onRefresh: () => cubit.loadOrders(),
      color: colorScheme.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Activity Header with active shipment counter
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.margin.w,
              AppConstants.spacingMD.h,
              AppConstants.margin.w,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: BlocSelector<OrdersCubit, OrdersState, int>(
                selector: (state) => state.activeShipmentsCount,
                builder: (context, activeCount) {
                  return OrdersActivityHeader(
                    activeShipmentsCount: activeCount,
                  );
                },
              ),
            ),
          ),

          // Search Bar
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.margin.w,
              AppConstants.spacingMD.h,
              AppConstants.margin.w,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: BlocSelector<OrdersCubit, OrdersState, String>(
                selector: (state) => state.searchQuery,
                builder: (context, query) {
                  return OrdersSearchBar(
                    initialQuery: query,
                    onQueryChanged: cubit.setSearchQuery,
                  );
                },
              ),
            ),
          ),

          // Filter Tab Bar
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.margin.w,
              AppConstants.spacingSM.h,
              AppConstants.margin.w,
              AppConstants.spacingMD.h,
            ),
            sliver: SliverToBoxAdapter(
              child:
                  BlocSelector<
                    OrdersCubit,
                    OrdersState,
                    (OrdersFilterTab, int, int)
                  >(
                    selector: (state) => (
                      state.selectedFilter,
                      state.orders.length,
                      state.activeShipmentsCount,
                    ),
                    builder: (context, data) {
                      final (filter, total, active) = data;
                      return OrdersFilterTabBar(
                        selectedTab: filter,
                        onTabChanged: cubit.setFilter,
                        totalCount: total,
                      );
                    },
                  ),
            ),
          ),

          // Orders List or States
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
            sliver: BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state.status == OrdersStatus.loading &&
                    state.orders.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.status == OrdersStatus.failure &&
                    state.orders.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: OrdersEmptyView(
                      title: 'Unable to Load Orders',
                      subtitle:
                          state.errorMessage ??
                          'Please check your connection and try again.',
                      onStartShoppingPressed: cubit.loadOrders,
                    ),
                  );
                }

                if (state.filteredOrders.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: OrdersEmptyView(
                      title: state.searchQuery.isNotEmpty
                          ? 'No Matching Orders'
                          : 'No Orders Yet',
                      subtitle: state.searchQuery.isNotEmpty
                          ? 'No orders match "${state.searchQuery}". Try a different search.'
                          : 'You have not placed any orders yet.',
                      onStartShoppingPressed: () => context.go(Routes.home),
                    ),
                  );
                }

                return SliverList.separated(
                  itemCount: state.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = state.filteredOrders[index];
                    return OrderCard(
                      order: order,
                      onViewDetails: (order) => _onViewDetails(context, order),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppConstants.spacingMD.h),
                );
              },
            ),
          ),

          // Bottom Spacing
          SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingXL.h)),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<OrdersCubit>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (flex: 4): Activity header, search bar, and filter tabs
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingSM.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocSelector<OrdersCubit, OrdersState, int>(
                  selector: (state) => state.activeShipmentsCount,
                  builder: (context, activeCount) {
                    return OrdersActivityHeader(
                      activeShipmentsCount: activeCount,
                    );
                  },
                ),
                SizedBox(height: AppConstants.spacingMD.h),
                BlocSelector<OrdersCubit, OrdersState, String>(
                  selector: (state) => state.searchQuery,
                  builder: (context, query) {
                    return OrdersSearchBar(
                      initialQuery: query,
                      onQueryChanged: cubit.setSearchQuery,
                    );
                  },
                ),
                SizedBox(height: AppConstants.spacingSM.h),
                BlocSelector<
                  OrdersCubit,
                  OrdersState,
                  (OrdersFilterTab, int, int)
                >(
                  selector: (state) => (
                    state.selectedFilter,
                    state.orders.length,
                    state.activeShipmentsCount,
                  ),
                  builder: (context, data) {
                    final (filter, total, active) = data;
                    return OrdersFilterTabBar(
                      selectedTab: filter,
                      onTabChanged: cubit.setFilter,
                      totalCount: total,
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Vertical Divider
        VerticalDivider(
          width: AppConstants.hairlineStrokeWidth,
          thickness: AppConstants.hairlineStrokeWidth,
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),

        // Right Column (flex: 6): Scrollable virtualized order cards
        Expanded(
          flex: 6,
          child: RefreshIndicator(
            onRefresh: () => cubit.loadOrders(),
            color: colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.margin.w,
                    vertical: AppConstants.spacingSM.h,
                  ),
                  sliver: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      if (state.status == OrdersStatus.loading &&
                          state.orders.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (state.status == OrdersStatus.failure &&
                          state.orders.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: OrdersEmptyView(
                            title: 'Unable to Load Orders',
                            subtitle:
                                state.errorMessage ??
                                'Please check your connection and try again.',
                            onStartShoppingPressed: cubit.loadOrders,
                          ),
                        );
                      }

                      if (state.filteredOrders.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: OrdersEmptyView(
                            title: state.searchQuery.isNotEmpty
                                ? 'No Matching Orders'
                                : 'No Orders Yet',
                            subtitle: state.searchQuery.isNotEmpty
                                ? 'No orders match "${state.searchQuery}". Try a different search.'
                                : 'You have not placed any orders yet.',
                            onStartShoppingPressed: () =>
                                context.go(Routes.home),
                          ),
                        );
                      }

                      return SliverList.separated(
                        itemCount: state.filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = state.filteredOrders[index];
                          return OrderCard(
                            order: order,
                            onViewDetails: (order) =>
                                _onViewDetails(context, order),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: AppConstants.spacingMD.h),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingXL.h),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
