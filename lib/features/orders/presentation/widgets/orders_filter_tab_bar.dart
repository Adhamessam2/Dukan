import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../cubit/orders_state.dart';

/// Horizontal scrollable filter pill tabs for order status.
/// Tabs: All · Pending · Processing · Shipped · Delivered · Cancelled
class OrdersFilterTabBar extends StatelessWidget {
  final OrdersFilterTab selectedTab;
  final ValueChanged<OrdersFilterTab> onTabChanged;
  final int totalCount;

  const OrdersFilterTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    this.totalCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            context,
            tab: OrdersFilterTab.all,
            label: 'All',
            badgeCount: totalCount > 0 ? totalCount : null,
          ),
          SizedBox(width: AppConstants.spacingSM.w),
          _buildTab(context, tab: OrdersFilterTab.pending, label: 'Pending'),
          SizedBox(width: AppConstants.spacingSM.w),
          _buildTab(
            context,
            tab: OrdersFilterTab.processing,
            label: 'Processing',
          ),
          SizedBox(width: AppConstants.spacingSM.w),
          _buildTab(context, tab: OrdersFilterTab.shipped, label: 'Shipped'),
          SizedBox(width: AppConstants.spacingSM.w),
          _buildTab(
            context,
            tab: OrdersFilterTab.delivered,
            label: 'Delivered',
          ),
          SizedBox(width: AppConstants.spacingSM.w),
          _buildTab(
            context,
            tab: OrdersFilterTab.cancelled,
            label: 'Cancelled',
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required OrdersFilterTab tab,
    required String label,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isSelected = selectedTab == tab;

    return InkWell(
      onTap: () => onTabChanged(tab),
      borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.margin.w,
          vertical: (AppConstants.spacingXS + 2.0).h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
          border: isSelected
              ? null
              : Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  width: AppConstants.hairlineStrokeWidth,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.surface
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (badgeCount != null) ...[
              SizedBox(width: AppConstants.spacingXS.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: (AppConstants.spacingXS + 2.0).w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.surface.withValues(alpha: 0.2)
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusFull.r,
                  ),
                ),
                child: Text(
                  badgeCount.toString(),
                  style: textTheme.labelSmall
                      ?.copyWith(
                        color: isSelected
                            ? colorScheme.surface
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      )
                      .withTabularFigures(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
