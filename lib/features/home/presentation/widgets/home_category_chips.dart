import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/category_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Horizontal scrollable category filter chips with shimmer loading
class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocSelector<
      HomeCubit,
      HomeState,
      (List<CategoryEntity>, int?, HomeStatus)
    >(
      selector: (state) =>
          (state.categories, state.selectedCategoryId, state.categoriesStatus),
      builder: (context, data) {
        final (categories, selectedCategoryId, status) = data;

        if (status == HomeStatus.loading && categories.isEmpty) {
          return _buildLoadingShimmer(colorScheme);
        }

        return SizedBox(
          height: 38.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
            itemCount: categories.length + 1,
            separatorBuilder: (context, index) =>
                SizedBox(width: AppConstants.spacingSM.w),
            itemBuilder: (context, index) {
              final isAllChip = index == 0;
              final isSelected = isAllChip
                  ? selectedCategoryId == null
                  : categories[index - 1].id == selectedCategoryId;

              final title = isAllChip
                  ? 'All'
                  : categories[index - 1].categoryName;
              final categoryId = isAllChip ? null : categories[index - 1].id;

              return InkWell(
                onTap: () {
                  context.read<HomeCubit>().selectCategory(categoryId);
                },
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                child: AnimatedContainer(
                  duration: AppConstants.shortAnimationDuration,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.inverseSurface
                        : colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusRound,
                    ),
                    boxShadow: isSelected ? AppConstants.elevationLevel2 : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onInverseSurface
                          : colorScheme.secondary,
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer(ColorScheme colorScheme) {
    return SizedBox(
      height: 38.h,
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainer,
        highlightColor: colorScheme.surfaceContainerLow,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppConstants.margin.w),
          itemCount: 5,
          separatorBuilder: (context, index) =>
              SizedBox(width: AppConstants.spacingSM.w),
          itemBuilder: (_, index) => Container(
            width: (60 + index * 15).w,
            height: 38.h,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            ),
          ),
        ),
      ),
    );
  }
}
