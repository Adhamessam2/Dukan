import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Delight card highlighting craftsmanship and sustainable quality
class HomeCraftsmanshipCard extends StatelessWidget {
  const HomeCraftsmanshipCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.margin.w,
        AppConstants.spacingLG.h,
        AppConstants.margin.w,
        AppConstants.spacingMD.h,
      ),
      child: Container(
        padding: EdgeInsets.all(AppConstants.spacingMD.r),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colorScheme.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.verified_outlined,
                  color: colorScheme.onPrimaryFixed,
                  size: 20.r,
                ),
              ),
            ),
            SizedBox(width: AppConstants.spacingMD.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Small-Batch & Sustainable',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Every piece is verified for artisanal integrity and durable materials.',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
