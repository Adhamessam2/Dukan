import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_payment_status_entity.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/order_details_cubit.dart';
import '../cubit/order_details_state.dart';
import 'payment_webview_args.dart';
import '../widgets/order_delivery_address_card.dart';
import '../widgets/order_details_bottom_bar.dart';
import '../widgets/order_details_header.dart';
import '../widgets/order_details_summary_card.dart';
import '../widgets/order_fulfillment_card.dart';
import '../widgets/order_items_card.dart';
import '../widgets/order_payment_details_card.dart';

/// Screen displaying the complete breakdown of a single order.
/// Matches Figma node 1:1306.
/// Implements landscape-safe single scrollable view centered in ConstrainedBox(maxWidth: 680).
class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Order Detail',
        showBackButton: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<OrderDetailsCubit>().loadOrderDetails(orderId),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: BlocSelector<
                OrderDetailsCubit,
                OrderDetailsState,
                (OrderDetailsStatus, OrderEntity?, OrderPaymentStatusEntity?)
              >(
                selector: (state) =>
                    (state.status, state.order, state.paymentStatus),
                builder: (context, data) {
                  final (status, order, paymentStatus) = data;
                  return switch (status) {
                    OrderDetailsStatus.initial ||
                    OrderDetailsStatus.loading =>
                      _buildLoadingView(),
                    OrderDetailsStatus.failure => _buildErrorView(context),
                    OrderDetailsStatus.success =>
                      _buildSuccessView(context, order, paymentStatus),
                  };
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocSelector<
        OrderDetailsCubit,
        OrderDetailsState,
        (bool, bool, bool, OrderEntity?, OrderPaymentStatusEntity?)
      >(
        selector: (state) => (
          state.status == OrderDetailsStatus.success,
          state.isReordering,
          state.isCancelling,
          state.order,
          state.paymentStatus,
        ),
        builder: (context, data) {
          final (isSuccess, isReordering, isCancelling, order, paymentStatus) =
              data;
          if (!isSuccess || order == null) {
            return const SizedBox.shrink();
          }

          final isPendingPayment =
              order.isPending &&
              order.paymentMethod == PaymentMethod.creditCard &&
              !order.isCancelled &&
              !(paymentStatus?.isPaid ?? false);

          return OrderDetailsBottomBar(
            isReordering: isReordering,
            isCancelling: isCancelling,
            isPendingPayment: isPendingPayment,
            totalAmount: order.totalAmount,
            onPayNowPressed: () {
              final checkoutUrl = order.payment?.checkoutUrl;
              if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
                context.push(
                  Routes.paymentWebView,
                  extra: PaymentWebViewArgs(url: checkoutUrl, order: order),
                );
              } else {
                context.showErrorSnackBar(
                  'Payment link is not available. Please try again later.',
                );
              }
            },
            onCancelOrderPressed: () =>
                _showCancelOrderDialog(context, order),
            onReorderAllPressed: () async {
              final cubit = context.read<OrderDetailsCubit>();
              final cartCubit = context.read<CartCubit>();
              await cubit.reorderAllItems(cartCubit);
              if (context.mounted) {
                context.push(Routes.cart);
              }
            },
            onNeedHelpPressed: () {
              context.showSnackBar(
                'Customer support is ready to help with order #DK-$orderId.',
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCancelOrderDialog(
    BuildContext context,
    OrderEntity order,
  ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cubit = context.read<OrderDetailsCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: Text(
          'Are you sure you want to cancel order #DK-${order.id}? '
          'Any held items will be returned to stock.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep Order'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await cubit.cancelOrder(order.id);
      if (context.mounted) {
        if (success) {
          context.showSnackBar('Order #DK-${order.id} was cancelled.');
        } else {
          final error = cubit.state.errorMessage;
          context.showErrorSnackBar(
            error ?? 'Failed to cancel order. Please try again.',
          );
        }
      }
    }
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXL.w,
          vertical: AppConstants.spacingMD.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: AppConstants.iconSizeXL.r,
              color: colorScheme.error,
            ),
            SizedBox(height: AppConstants.spacingMD.h),
            BlocSelector<OrderDetailsCubit, OrderDetailsState, String?>(
              selector: (state) => state.errorMessage,
              builder: (context, errorMessage) {
                return Text(
                  errorMessage ?? AppConstants.genericErrorMessage,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            SizedBox(height: AppConstants.spacingLG.h),
            CustomButton(
              text: 'Retry',
              onPressed: () =>
                  context.read<OrderDetailsCubit>().loadOrderDetails(orderId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    OrderEntity? order,
    OrderPaymentStatusEntity? paymentStatus,
  ) {
    if (order == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingMD.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. OrderDetailsHeader: Bullet + #DK-${order.id} + Invoice pill
          OrderDetailsHeader(
            order: order,
            onInvoicePressed: () {
              context.showSnackBar('Invoice downloading...');
            },
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // 2. OrderFulfillmentCard: Status icon, overline, headline date, chip
          OrderFulfillmentCard(order: order),
          SizedBox(height: AppConstants.spacingMD.h),

          // 3. OrderItemsCard: Item list with "Buy Again"
          OrderItemsCard(
            order: order,
            onBuyAgain: (item) async {
              await context.read<CartCubit>().addToCart(
                    productId: item.product.id,
                    quantity: item.quantity,
                  );
              if (context.mounted) {
                context.push(Routes.cart);
              }
            },
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // 4. OrderDeliveryAddressCard: Location pin + address details
          OrderDeliveryAddressCard(order: order),
          SizedBox(height: AppConstants.spacingMD.h),

          // 5. OrderPaymentDetailsCard: Method, provider, ref, shield
          OrderPaymentDetailsCard(
            order: order,
            paymentStatus: paymentStatus,
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // 6. OrderDetailsSummaryCard: Calculations and total paid
          OrderDetailsSummaryCard(order: order),
          SizedBox(height: AppConstants.spacingMD.h),
        ],
      ),
    );
  }
}
