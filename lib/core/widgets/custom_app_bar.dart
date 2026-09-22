import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';

/// Reusable top header bar implementing [PreferredSizeWidget].
/// Conforms to design system tokens and repaint isolation per AGENTS.md.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.onBackTap,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(
    AppConstants.headerHeight.h.clamp(
      AppConstants.minHeaderHeight,
      AppConstants.maxHeaderHeight,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: EdgeInsets.symmetric(
            horizontal: (showBackButton || leading != null)
                ? AppConstants.spacingXS.w
                : AppConstants.margin.w,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.96),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
          ),
          child: Row(
            children: [
              if (showBackButton)
                IconButton(
                  onPressed:
                      onBackTap ?? () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: colorScheme.onSurface,
                    size: AppConstants.iconSizeSM.r,
                  ),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
              if (leading != null) ...[
                leading!,
                SizedBox(width: AppConstants.spacingSM.w),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        height: 1.15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: (AppConstants.spacingXS / 2).h),
                      Text(
                        subtitle!,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                          height: 1.15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
