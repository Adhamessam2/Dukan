import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';

/// Interactive Segmented Pill Switcher between "Sign In" and "Create Account".
class AuthSegmentedSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const AuthSegmentedSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 46.h,
      padding: EdgeInsets.all(AppConstants.spaceXS.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated Sliding Active Pill Thumb
          AnimatedAlign(
            duration: AppConstants.mediumAnimationDuration,
            curve: Curves.easeInOutCubic,
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Two Interactive Tab Labels
          Row(
            children: [
              // Sign In Tab
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(0),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: AppConstants.shortAnimationDuration,
                      style: AppTypography.labelMd.copyWith(
                        color: selectedIndex == 0
                            ? colorScheme.onInverseSurface
                            : colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                ),
              ),

              // Create Account Tab
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(1),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: AppConstants.shortAnimationDuration,
                      style: AppTypography.labelMd.copyWith(
                        color: selectedIndex == 1
                            ? colorScheme.onInverseSurface
                            : colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      child: const Text('Create Account'),
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
