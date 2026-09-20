import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Top header bar for the Cart screen displaying Dukaan branding with "Cart" subtitle,
/// notifications, and profile avatar.
/// Wrapped in RepaintBoundary for repaint isolation.
class CartHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const CartHeader({super.key, this.onNotificationTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: Container(
        height: AppConstants.headerHeight.h.clamp(56.0, 72.0),
        padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.95),
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              width: AppConstants.hairlineStrokeWidth,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Brand Logo, Name & Screen Subtitle
            Row(
              children: [
                Container(
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
                SizedBox(width: AppConstants.spacingSM.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dukaan',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Cart',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Notification & Profile Actions
            Row(
              children: [
                IconButton(
                  onPressed: onNotificationTap,
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: colorScheme.onSurface,
                    size: AppConstants.iconSizeMD.r,
                  ),
                  splashRadius: AppConstants.iconSizeMD.r,
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                InkWell(
                  onTap: onProfileTap,
                  borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                  child: Container(
                    width: AppConstants.avatarSizeSM.r,
                    height: AppConstants.avatarSizeSM.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                        width: AppConstants.hairlineStrokeWidth,
                      ),
                      color: colorScheme.surfaceContainerHigh,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: AppConstants.controlSize.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
