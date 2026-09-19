import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Header row for products section with dynamic item count and sort trigger
class HomeSectionHeader extends StatelessWidget {
  final VoidCallback? onSortTap;

  const HomeSectionHeader({super.key, this.onSortTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.margin.w,
        AppConstants.spacingMD.h,
        AppConstants.margin.w,
        AppConstants.spacingXS.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section Title & Dynamic Count
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    'Featured Products',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                SizedBox(width: AppConstants.spacingSM.w),
                BlocSelector<HomeCubit, HomeState, int>(
                  selector: (state) => state.filteredProducts.length,
                  builder: (context, count) {
                    return Text(
                      '$count items',
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: AppConstants.spacingSM.w),

          // Sort Button
          InkWell(
            onTap: onSortTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusDefault),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSM.w,
                vertical: AppConstants.spacingXS.h,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.swap_vert_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 16.r,
                  ),
                  SizedBox(width: 4.w),
                  BlocSelector<HomeCubit, HomeState, ProductSortOption>(
                    selector: (state) => state.sortOption,
                    builder: (context, sortOption) {
                      return Text(
                        sortOption == ProductSortOption.curated
                            ? 'Sort by: Curated'
                            : sortOption.label,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
