import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// Card container encapsulating customer shipping address inputs.
/// Adheres strictly to AGENTS.md: themed tokens, AppConstants sizing, and zero keystroke rebuilds.
class ShippingInformationCard extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController cityController;

  const ShippingInformationCard({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.streetController,
    required this.buildingController,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppConstants.margin.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: AppConstants.hairlineStrokeWidth,
        ),
        boxShadow: AppConstants.elevationLevel2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Delivery Icon and Title
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
                  Icons.local_shipping_outlined,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: AppConstants.spacingSM.w),
              Expanded(
                child: Text(
                  'Shipping Information',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.spacingMD.h),

          // Full Name
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: fullNameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              size: AppConstants.iconSizeSM.r,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppConstants.spacingSM.h + AppConstants.spacingXS.h),

          // Phone Number
          CustomTextField(
            label: 'Phone Number',
            hint: 'Enter phone number',
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            prefixIcon: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSM.w,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+1',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingXS.w),
                  Container(
                    width: AppConstants.hairlineStrokeWidth,
                    height: AppConstants.iconSizeSM.h,
                    color: colorScheme.outlineVariant,
                  ),
                ],
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: AppConstants.avatarSizeSM.w,
              minHeight: AppConstants.controlSize.h,
            ),
          ),
          SizedBox(height: AppConstants.spacingSM.h + AppConstants.spacingXS.h),

          // Street
          CustomTextField(
            label: 'Street',
            hint: 'Street name and number',
            controller: streetController,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.location_on_outlined,
              size: AppConstants.iconSizeSM.r,
              color: colorScheme.onSurfaceVariant,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Street address is required';
              }
              return null;
            },
          ),
          SizedBox(height: AppConstants.spacingSM.h + AppConstants.spacingXS.h),

          // Building / Apartment Number
          CustomTextField(
            label: 'Building / Apartment Number',
            hint: 'Building, floor, or apt number',
            controller: buildingController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            prefixIcon: Icon(
              Icons.apartment_outlined,
              size: AppConstants.iconSizeSM.r,
              color: colorScheme.onSurfaceVariant,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Building / Apartment is required';
              }
              return null;
            },
          ),
          SizedBox(height: AppConstants.spacingSM.h + AppConstants.spacingXS.h),

          // City
          CustomTextField(
            label: 'City',
            hint: 'Enter your city',
            controller: cityController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            prefixIcon: Icon(
              Icons.location_city_outlined,
              size: AppConstants.iconSizeSM.r,
              color: colorScheme.onSurfaceVariant,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'City is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
