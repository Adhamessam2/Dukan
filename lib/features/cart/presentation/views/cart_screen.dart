import 'package:Dukan/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_empty_view.dart';
import '../widgets/cart_header.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_order_summary_card.dart';
import '../widgets/cart_sticky_checkout_bar.dart';
import '../widgets/cart_trust_badges.dart';

/// The Cart Screen matching Figma design node 1:479.
/// Integrates Clean Architecture with sliver virtualization, granular rebuilds,
/// and anti-jank performance.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  void _handleCheckout(BuildContext context) {
    context.push(Routes.checkout, extra: context.read<CartCubit>().state.cart);
  }

  void _confirmClearCart(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: const Text('Clear Bag'),
        content: const Text(
          'Are you sure you want to remove all items from your bag?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(
              'Cancel',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop(true);
              cubit.clearCart();
            },
            child: Text(
              'Clear all',
              style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRemoveItem({
    required CartItemEntity item,
    required String cartIdStr,
  }) async {
    final cubit = context.read<CartCubit>();
    final productIdStr = item.productId.toString();
    final count = item.quantity;

    for (var i = 0; i < count; i++) {
      await cubit.deleteCartItem(cartId: cartIdStr, productId: productIdStr);
      if (cubit.state.deletedCartItem?.isDeleted == true ||
          cubit.state.deleteCartItemStatus == CartStatus.failure) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // Listener for Add to Cart
            BlocListener<CartCubit, CartState>(
              listenWhen: (prev, curr) =>
                  prev.status != curr.status &&
                  curr.status == CartStatus.success,
              listener: (context, state) {
                context.read<CartCubit>().getCart();
              },
            ),

            // Error listener for Get Cart
            BlocListener<CartCubit, CartState>(
              listenWhen: (prev, curr) =>
                  prev.getCartStatus != curr.getCartStatus &&
                  curr.getCartStatus == CartStatus.failure &&
                  curr.getCartErrorMessage != null,
              listener: (context, state) {
                context.showErrorSnackBar(
                  state.getCartErrorMessage ?? AppConstants.genericErrorMessage,
                );
              },
            ),

            // Listener for Update Cart Item
            BlocListener<CartCubit, CartState>(
              listenWhen: (prev, curr) =>
                  prev.updateCartItemStatus != curr.updateCartItemStatus,
              listener: (context, state) {
                if (state.updateCartItemStatus == CartStatus.failure &&
                    state.updateCartItemErrorMessage != null) {
                  context.showErrorSnackBar(state.updateCartItemErrorMessage!);
                }
              },
            ),

            // Listener for Delete Cart Item
            BlocListener<CartCubit, CartState>(
              listenWhen: (prev, curr) =>
                  prev.deleteCartItemStatus != curr.deleteCartItemStatus,
              listener: (context, state) {
                if (state.deleteCartItemStatus == CartStatus.success &&
                    state.deletedCartItem?.isDeleted != false) {
                  context.showSuccessSnackBar('Item removed from your bag');
                } else if (state.deleteCartItemStatus == CartStatus.failure &&
                    state.deleteCartItemErrorMessage != null) {
                  context.showErrorSnackBar(state.deleteCartItemErrorMessage!);
                }
              },
            ),

            // Listener for Clear Cart
            BlocListener<CartCubit, CartState>(
              listenWhen: (prev, curr) =>
                  prev.clearCartStatus != curr.clearCartStatus,
              listener: (context, state) {
                if (state.clearCartStatus == CartStatus.success) {
                  context.showSuccessSnackBar('Your bag has been cleared');
                } else if (state.clearCartStatus == CartStatus.failure &&
                    state.clearCartErrorMessage != null) {
                  context.showErrorSnackBar(state.clearCartErrorMessage!);
                }
              },
            ),
          ],
          child: Column(
            children: [
              // Top Header
              const CartHeader(),

              // Content Area
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  buildWhen: (prev, curr) =>
                      prev.getCartStatus != curr.getCartStatus ||
                      prev.cart != curr.cart ||
                      prev.pendingProductIds != curr.pendingProductIds,
                  builder: (context, state) {
                    // Initial loading with no prior data
                    if (state.getCartStatus == CartStatus.loading &&
                        state.cart == null) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      );
                    }

                    // Failure with no prior data
                    if (state.getCartStatus == CartStatus.failure &&
                        state.cart == null) {
                      return Center(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(AppConstants.margin.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.getCartErrorMessage ??
                                    AppConstants.genericErrorMessage,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppConstants.spacingMD.h),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<CartCubit>().getCart(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                ),
                                child: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final cart = state.cart;

                    // Empty Bag State
                    if (cart == null || cart.items.isEmpty) {
                      return CartEmptyView(
                        onBrowsePressed: () => context.go(Routes.home),
                      );
                    }

                    final items = cart.items;
                    final cartIdStr = cart.id.toString();
                    final isLandscape =
                        MediaQuery.orientationOf(context) ==
                        Orientation.landscape;

                    return isLandscape
                        ? _buildLandscapeLayout(
                            context,
                            state,
                            cart,
                            items,
                            cartIdStr,
                          )
                        : _buildPortraitLayout(
                            context,
                            state,
                            cart,
                            items,
                            cartIdStr,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (MediaQuery.orientationOf(context) != Orientation.landscape)
            BlocSelector<CartCubit, CartState, (bool, double)>(
              selector: (state) => (
                state.cart != null && state.cart!.items.isNotEmpty,
                state.cart?.totalPrice ?? 0.0,
              ),
              builder: (context, data) {
                final (hasItems, totalPrice) = data;
                if (!hasItems) return const SizedBox.shrink();
                return CartStickyCheckoutBar(
                  totalPrice: totalPrice,
                  onCheckoutPressed: () => _handleCheckout(context),
                );
              },
            ),
          BlocSelector<CartCubit, CartState, int>(
            selector: (state) => state.cart?.items.length ?? 0,
            builder: (context, count) => HomeBottomNavBar(
              selectedIndex: 1,
              cartItemCount: count,
              onIndexChanged: (index) {
                if (index == 0) {
                  context.go(Routes.home);
                } else if (index == 2) {
                  context.push(Routes.orders);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBagHeader(BuildContext context, int itemCount) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Bag',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(width: AppConstants.spacingSM.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingSM.w,
                    vertical: AppConstants.spacingXS.h / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusRound,
                    ),
                  ),
                  child: Text(
                    '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Clear All Button
        InkWell(
          onTap: () => _confirmClearCart(context),
          borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXS.w,
              vertical: AppConstants.spacingXS.h,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete_sweep_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                Text(
                  'Clear all',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItemEntity item,
    String cartIdStr,
  ) {
    final productIdStr = item.productId.toString();
    return CartItemCard(
      item: item,
      onIncrement: () {
        final state = context.read<CartCubit>().state;
        if (state.updateCartItemStatus == CartStatus.loading ||
            state.deleteCartItemStatus == CartStatus.loading) {
          return;
        }
        context.read<CartCubit>().updateCartItem(
          cartId: cartIdStr,
          productId: productIdStr,
          quantity: item.quantity + 1,
        );
      },
      onDecrement: () {
        final state = context.read<CartCubit>().state;
        if (state.updateCartItemStatus == CartStatus.loading ||
            state.deleteCartItemStatus == CartStatus.loading) {
          return;
        }
        if (item.quantity > 1) {
          context.read<CartCubit>().updateCartItem(
            cartId: cartIdStr,
            productId: productIdStr,
            quantity: item.quantity - 1,
          );
        } else {
          context.read<CartCubit>().deleteCartItem(
            cartId: cartIdStr,
            productId: productIdStr,
          );
        }
      },
      onRemove: () {
        final state = context.read<CartCubit>().state;
        if (state.updateCartItemStatus == CartStatus.loading ||
            state.deleteCartItemStatus == CartStatus.loading) {
          return;
        }
        context.read<CartCubit>().deleteCartItem(
          cartId: cartIdStr,
          productId: productIdStr,
        );
      },
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    CartState state,
    CartEntity cart,
    List<CartItemEntity> items,
    String cartIdStr,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<CartCubit>().getCart(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Bag Header Row
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingMD.h,
            ),
            sliver: SliverToBoxAdapter(
              child: _buildBagHeader(context, items.length),
            ),
          ),

          // Virtualized Items List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  SizedBox(height: AppConstants.spacingSM.h),
              itemBuilder: (context, index) =>
                  _buildCartItem(context, items[index], cartIdStr),
            ),
          ),

          // Order Summary Card
          SliverPadding(
            padding: EdgeInsets.only(
              left: AppConstants.margin.w,
              right: AppConstants.margin.w,
              top: AppConstants.spacingMD.h,
            ),
            sliver: SliverToBoxAdapter(
              child: CartOrderSummaryCard(totalPrice: cart.totalPrice),
            ),
          ),

          // Trust Badges
          const SliverToBoxAdapter(child: CartTrustBadges()),

          // Bottom spacing
          SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingMD.h)),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    CartState state,
    CartEntity cart,
    List<CartItemEntity> items,
    String cartIdStr,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Column: Items List (flex: 5)
        Expanded(
          flex: 5,
          child: RefreshIndicator(
            onRefresh: () => context.read<CartCubit>().getCart(),
            color: colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Bag Header Row
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.margin.w,
                    vertical: AppConstants.spacingSM.h,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _buildBagHeader(context, items.length),
                  ),
                ),

                // Virtualized Items List
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.margin.w,
                  ),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: AppConstants.spacingSM.h),
                    itemBuilder: (context, index) =>
                        _buildCartItem(context, items[index], cartIdStr),
                  ),
                ),

                // Bottom spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingMD.h),
                ),
              ],
            ),
          ),
        ),

        // Vertical Divider between columns
        VerticalDivider(
          width: AppConstants.hairlineStrokeWidth,
          thickness: AppConstants.hairlineStrokeWidth,
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),

        // Right Column: Order Summary (fixed & compact), Trust Badges, and Anchored Checkout CTA (flex: 4)
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingSM.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CartOrderSummaryCard(
                          totalPrice: cart.totalPrice,
                          isCompact: true,
                        ),
                        SizedBox(height: AppConstants.spacingXS.h),
                        const CartTrustBadges(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.spacingSM.h),
                // Anchored Checkout Button at bottom
                SizedBox(
                  height: AppConstants.buttonHeight.h.clamp(
                    AppConstants.searchBarHeight,
                    AppConstants.buttonHeight,
                  ),
                  child: Material(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusMD.r,
                    ),
                    child: InkWell(
                      onTap: () => _handleCheckout(context),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMD.r,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.margin.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: AppConstants.iconSizeSM.r,
                                    color: colorScheme.onPrimary,
                                  ),
                                  SizedBox(width: AppConstants.spacingSM.w),
                                  Expanded(
                                    child: Text(
                                      'Proceed to Checkout',
                                      style: textTheme.labelLarge?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppConstants.spacingSM.w),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                                  style: textTheme.labelLarge
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.sp,
                                      )
                                      .withTabularFigures(),
                                ),
                                SizedBox(width: AppConstants.spacingXS.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: AppConstants.iconSizeSM.r,
                                  color: colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
