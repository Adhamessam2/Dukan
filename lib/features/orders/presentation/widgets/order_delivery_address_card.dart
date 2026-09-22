import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/order_entity.dart';

/// Card displaying the shipping address details with a location pin header.
/// Matching Figma node 1:1306.
class OrderDeliveryAddressCard extends StatelessWidget {
  final OrderEntity order;

  const OrderDeliveryAddressCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.margin.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: AppConstants.hairlineStrokeWidth,
        ),
        boxShadow: AppConstants.elevationLevel2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Location Pin Icon + "Delivery Address"
          Row(
            children: [
              Container(
                width: AppConstants.avatarSizeSM.r,
                height: AppConstants.avatarSizeSM.r,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Text(
                'Delivery Address',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Formatted address lines
          if (order.shippingBuilding.isNotEmpty) ...[
            Text(
              'Building ${order.shippingBuilding}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: (AppConstants.spacingXS / 2).h),
          ],
          Text(
            order.shippingStreet,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: (AppConstants.spacingXS / 2).h),
          Text(
            order.shippingCity,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
