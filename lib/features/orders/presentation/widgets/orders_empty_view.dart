import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button.dart';

/// Empty state presentation when the orders list or filtered result is empty.
/// Wrapped in a SingleChildScrollView to ensure zero RenderFlex overflow on landscape viewports.
class OrdersEmptyView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onStartShoppingPressed;

  const OrdersEmptyView({
    super.key,
    this.title = 'No Orders Found',
    this.subtitle = 'Browse our collection and place your first order.',
    this.onStartShoppingPressed,
  });

  @override
  Widget build(BuildContext context) {
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppConstants.avatarSizeXL.r.clamp(
                  AppConstants.avatarSizeLG,
                  AppConstants.avatarSizeXL,
                ),
                height: AppConstants.avatarSizeXL.r.clamp(
                  AppConstants.avatarSizeLG,
                  AppConstants.avatarSizeXL,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.receipt_long_outlined,
                    size: AppConstants.iconSizeXL.r.clamp(
                      AppConstants.iconSizeLG,
                      AppConstants.iconSizeXL,
                    ),
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                height: AppConstants.spacingLG.h.clamp(
                  AppConstants.gutter,
                  AppConstants.spacingLG,
                ),
              ),
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppConstants.spacingSM.h.clamp(
                  AppConstants.spacingXS,
                  AppConstants.spacingSM,
                ),
              ),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppConstants.spacingXL.h.clamp(
                  AppConstants.spacingMD,
                  AppConstants.spacingXL,
                ),
              ),
              if (onStartShoppingPressed != null)
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Start Shopping',
                    prefixIcon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: onStartShoppingPressed,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
