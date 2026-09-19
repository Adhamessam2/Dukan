import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Bottom Navigation Bar matching Figma design specifications
class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onIndexChanged;
  final int cartItemCount;

  const HomeBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.onIndexChanged,
    this.cartItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        boxShadow: AppConstants.elevationLevel3,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppConstants.bottomNavBarHeight.h.clamp(56.0, 72.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.home_filled,
                label: 'Home',
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.explore_outlined,
                label: 'Browse',
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.shopping_bag_outlined,
                label: 'Cart',
                badgeCount: cartItemCount,
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.receipt_long_outlined,
                label: 'Orders',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isSelected = selectedIndex == index;
    final activeColor = colorScheme.onSurfaceVariant;
    final inactiveColor = colorScheme.secondary;

    return InkWell(
      onTap: () => onIndexChanged?.call(index),
      borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.margin.w,
          vertical: 4.h.clamp(2.0, 6.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: AppConstants.controlSize.r,
                  color: isSelected ? activeColor : inactiveColor,
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -4.h,
                    right: -8.w,
                    child: Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14.r,
                        minHeight: 14.r,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
