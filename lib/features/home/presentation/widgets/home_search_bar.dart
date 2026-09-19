import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Search input bar with voice search and filter button
class HomeSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onVoiceSearchTap;
  final VoidCallback? onFilterTap;

  const HomeSearchBar({
    super.key,
    this.onSearchChanged,
    this.onVoiceSearchTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final searchBarHeight = AppConstants.searchBarHeight.h.clamp(
      40.0,
      AppConstants.buttonHeight,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.margin.w,
        vertical: AppConstants.spacingSM.h,
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              height: searchBarHeight,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
              ),
              child: Row(
                children: [
                  SizedBox(width: AppConstants.spacingMD.w),
                  Icon(
                    Icons.search_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 18.r,
                  ),
                  SizedBox(width: AppConstants.spacingSM.w),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search ceramics, apparel, goods...',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        isDense: true,
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onVoiceSearchTap,
                    icon: Icon(
                      Icons.mic_none_rounded,
                      color: colorScheme.secondary,
                      size: 18.r,
                    ),
                    splashRadius: 18.r,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: AppConstants.spacingSM.w),

          // Filter Button
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            child: Container(
              width: searchBarHeight,
              height: searchBarHeight,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                shape: BoxShape.circle,
                boxShadow: AppConstants.elevationLevel2,
              ),
              child: Center(
                child: Icon(
                  Icons.tune_rounded,
                  color: colorScheme.onSurface,
                  size: 18.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
