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
      height: 64.h,
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            width: AppConstants.hairlineStrokeWidth,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
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
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    int? badgeCount,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedIndex == index;
    final activeColor = colorScheme.onSurfaceVariant;
    final inactiveColor = colorScheme.secondary;

    return InkWell(
      onTap: () => onIndexChanged?.call(index),
      borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 20.r,
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
                          style: TextStyle(
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
              style: TextStyle(
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
