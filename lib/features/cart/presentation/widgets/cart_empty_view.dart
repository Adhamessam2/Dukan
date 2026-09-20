import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button.dart';

/// Empty state presentation when cart has 0 items.
class CartEmptyView extends StatelessWidget {
  final VoidCallback? onBrowsePressed;

  const CartEmptyView({super.key, this.onBrowsePressed});

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
                    Icons.shopping_bag_outlined,
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
                'Your Bag is Empty',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: AppConstants.spacingSM.h.clamp(
                  AppConstants.spacingXS,
                  AppConstants.spacingSM,
                ),
              ),
              Text(
                'Explore our curated collection and add your favorite pieces to your bag.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(
                height: AppConstants.spacingXL.h.clamp(
                  AppConstants.spacingMD,
                  AppConstants.spacingXL,
                ),
              ),
              CustomButton(
                text: 'Start Shopping',
                onPressed: onBrowsePressed,
                variant: CustomButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
