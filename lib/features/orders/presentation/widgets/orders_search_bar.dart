import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/constants.dart';

/// Orders search input bar matching Figma node 1:1090.
/// Features a rounded input with search icon, clear button, and debounced query dispatch.
class OrdersSearchBar extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;
  final Duration debounceDuration;

  const OrdersSearchBar({
    super.key,
    this.initialQuery = '',
    required this.onQueryChanged,
    this.debounceDuration = const Duration(milliseconds: 250),
  });

  @override
  State<OrdersSearchBar> createState() => _OrdersSearchBarState();
}

class _OrdersSearchBarState extends State<OrdersSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  void _handleChanged(String text) {
    if (widget.debounceDuration == Duration.zero) {
      widget.onQueryChanged(text);
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onQueryChanged(text);
    });
  }

  @override
  void didUpdateWidget(covariant OrdersSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery &&
        _controller.text != widget.initialQuery) {
      _controller.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      height: AppConstants.searchBarHeight.h.clamp(
        AppConstants.searchBarHeight - 4.0,
        AppConstants.searchBarHeight + 8.0,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: AppConstants.hairlineStrokeWidth,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controller,
          onChanged: _handleChanged,
          textInputAction: TextInputAction.search,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingSM.w,
              vertical: AppConstants.spacingSM.h,
            ),
            hintText: 'Search orders by ID or product...',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: AppConstants.iconSizeMD.r,
              color: colorScheme.onSurfaceVariant,
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: AppConstants.iconSizeXL.r,
              minHeight: AppConstants.iconSizeMD.r,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: AppConstants.iconSizeSM.r,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _debounceTimer?.cancel();
                    _controller.clear();
                    widget.onQueryChanged('');
                  },
                );
              },
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
