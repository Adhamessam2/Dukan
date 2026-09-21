import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button.dart';

/// Sticky bottom bar with "Reorder All Items" primary CTA and "Need Help with this Order?" link.
/// Wrapped in RepaintBoundary and SafeArea for optimal rendering performance.
/// Matching Figma node 1:1306.
class OrderDetailsBottomBar extends StatelessWidget {
  final VoidCallback? onReorderAllPressed;
  final VoidCallback? onNeedHelpPressed;
  final bool isReordering;

  const OrderDetailsBottomBar({
    super.key,
    required this.onReorderAllPressed,
    this.onNeedHelpPressed,
    this.isReordering = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: AppConstants.hairlineStrokeWidth,
            ),
          ),
          boxShadow: AppConstants.elevationLevel3,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.margin.w,
              vertical: AppConstants.spacingSM.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Reorder All Items CTA
                CustomButton(
                  text: 'Reorder All Items',
                  onPressed: onReorderAllPressed,
                  isLoading: isReordering,
                  prefixIcon: Icon(
                    Icons.replay_rounded,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.onPrimary,
                  ),
                ),
                SizedBox(height: AppConstants.spacingXS.h),

                // Need Help Link
                TextButton.icon(
                  onPressed: onNeedHelpPressed,
                  icon: Icon(
                    Icons.headset_mic_outlined,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  label: Text(
                    'Need Help with this Order?',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
