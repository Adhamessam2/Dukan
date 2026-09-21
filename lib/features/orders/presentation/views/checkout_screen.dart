import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';
import '../widgets/checkout_order_summary_card.dart';
import '../widgets/checkout_step_indicator.dart';
import '../widgets/checkout_sticky_bottom_bar.dart';
import '../widgets/order_success_dialog.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/shipping_information_card.dart';

/// CheckoutScreen coordinates shipping address entry, order review, payment selection,
/// and order submission adhering to Clean Architecture and AGENTS.md design tokens.
class CheckoutScreen extends StatefulWidget {
  final CartEntity? cart;

  const CheckoutScreen({super.key, this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _streetController;
  late final TextEditingController _buildingController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _streetController = TextEditingController();
    _buildingController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() == true) {
      context.read<CheckoutCubit>().submitOrder(
        city: _cityController.text,
        street: _streetController.text,
        building: _buildingController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CheckoutCubit, CheckoutState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status &&
                curr.status == CheckoutStatus.failure,
            listener: (context, state) {
              context.showErrorSnackBar(
                state.errorMessage ?? AppConstants.genericErrorMessage,
              );
            },
          ),
          BlocListener<CheckoutCubit, CheckoutState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status &&
                curr.status == CheckoutStatus.success &&
                curr.createdOrder != null,
            listener: (context, state) {
              try {
                context.read<CartCubit>().clearCart();
              } catch (_) {}

              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) => OrderSuccessDialog(
                  order: state.createdOrder!,
                  onContinueShopping: () {
                    Navigator.of(dialogCtx).pop();
                    context.go(Routes.home);
                  },
                  onTrackOrders: () {
                    Navigator.of(dialogCtx).pop();
                    context.go(Routes.orders);
                  },
                ),
              );
            },
          ),
        ],
        child: Form(
          key: _formKey,
          child: isLandscape
              ? _buildLandscapeLayout(context)
              : _buildPortraitLayout(context),
        ),
      ),
      bottomNavigationBar: isLandscape
          ? null
          : BlocSelector<CheckoutCubit, CheckoutState, (PaymentMethod, bool)>(
              selector: (state) => (
                state.selectedPaymentMethod,
                state.status == CheckoutStatus.submitting,
              ),
              builder: (context, data) {
                final (method, isLoading) = data;
                return CheckoutStickyBottomBar(
                  totalPrice: widget.cart?.totalPrice ?? 0.0,
                  paymentMethod: method,
                  isLoading: isLoading,
                  onSubmitPressed: _handleSubmit,
                );
              },
            ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: CheckoutStepIndicator()),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
          sliver: SliverToBoxAdapter(
            child: ShippingInformationCard(
              fullNameController: _fullNameController,
              phoneController: _phoneController,
              streetController: _streetController,
              buildingController: _buildingController,
              cityController: _cityController,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingMD.h)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
          sliver: SliverToBoxAdapter(
            child: CheckoutOrderSummaryCard(cart: widget.cart),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingMD.h)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
          sliver: SliverToBoxAdapter(
            child: BlocSelector<CheckoutCubit, CheckoutState, PaymentMethod>(
              selector: (state) => state.selectedPaymentMethod,
              builder: (context, method) => PaymentMethodCard(
                selectedMethod: method,
                onMethodSelected: (newMethod) => context
                    .read<CheckoutCubit>()
                    .selectPaymentMethod(newMethod),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingLG.h)),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Column (flex: 6): Step indicator, shipping card, payment method card
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingSM.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CheckoutStepIndicator(),
                SizedBox(height: AppConstants.spacingSM.h),
                ShippingInformationCard(
                  fullNameController: _fullNameController,
                  phoneController: _phoneController,
                  streetController: _streetController,
                  buildingController: _buildingController,
                  cityController: _cityController,
                ),
                SizedBox(height: AppConstants.spacingMD.h),
                BlocSelector<CheckoutCubit, CheckoutState, PaymentMethod>(
                  selector: (state) => state.selectedPaymentMethod,
                  builder: (context, method) => PaymentMethodCard(
                    selectedMethod: method,
                    onMethodSelected: (newMethod) => context
                        .read<CheckoutCubit>()
                        .selectPaymentMethod(newMethod),
                  ),
                ),
                SizedBox(height: AppConstants.spacingMD.h),
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

        // Right Column (flex: 5): Order summary, sticky bottom bar
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingSM.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CheckoutOrderSummaryCard(cart: widget.cart),
                SizedBox(height: AppConstants.spacingMD.h),
                BlocSelector<
                  CheckoutCubit,
                  CheckoutState,
                  (PaymentMethod, bool)
                >(
                  selector: (state) => (
                    state.selectedPaymentMethod,
                    state.status == CheckoutStatus.submitting,
                  ),
                  builder: (context, data) {
                    final (method, isLoading) = data;
                    return CheckoutStickyBottomBar(
                      totalPrice: widget.cart?.totalPrice ?? 0.0,
                      paymentMethod: method,
                      isLoading: isLoading,
                      onSubmitPressed: _handleSubmit,
                    );
                  },
                ),
                SizedBox(height: AppConstants.spacingMD.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
