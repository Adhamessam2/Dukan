import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Top header bar displaying Dukaan logo, notifications, and profile avatar
class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({super.key, this.onNotificationTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 64.h,
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
          // Brand Logo & Name
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'D',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Text(
                'Dukaan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  letterSpacing: -0.5,
                ),
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
                splashRadius: 22.r,
              ),
              SizedBox(width: AppConstants.spacingXS.w),
              InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                child: Container(
                  width: 34.r,
                  height: 34.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    color: colorScheme.surfaceContainerHigh,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
