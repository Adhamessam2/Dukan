import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../utils/constants.dart';

enum CustomButtonVariant {
  primary,
  secondary,
  outline,
}

/// A versatile, tactile button complying with "Warm Architectural Minimalism".
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final CustomButtonVariant variant;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.variant = CustomButtonVariant.primary,
    this.color,
    this.textColor,
    this.width,
    this.height = AppConstants.buttonHeight,
    this.borderRadius = AppConstants.radiusMD,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  CustomButtonVariant get _effectiveVariant {
    if (widget.isOutlined) {
      return CustomButtonVariant.outline;
    }
    return widget.variant;
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? side;

    switch (_effectiveVariant) {
      case CustomButtonVariant.primary:
        backgroundColor = widget.color ?? colorScheme.primary;
        foregroundColor = widget.textColor ?? colorScheme.onPrimary;
        side = BorderSide.none;
        break;
      case CustomButtonVariant.secondary:
        backgroundColor = widget.color ?? colorScheme.onSurface;
        foregroundColor = widget.textColor ?? colorScheme.surface;
        side = BorderSide.none;
        break;
      case CustomButtonVariant.outline:
        backgroundColor = widget.color ?? Colors.transparent;
        foregroundColor = widget.textColor ?? colorScheme.onSurface;
        side = BorderSide(
          color: colorScheme.outlineVariant,
          width: AppConstants.hairlineStrokeWidth,
        );
        break;
    }

    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: ElevatedButton(
            onPressed: isDisabled ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
              disabledForegroundColor: foregroundColor.withValues(alpha: 0.5),
              elevation: 0,
              shadowColor: Colors.transparent,
              side: side,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMD,
              ),
              textStyle: AppTypography.labelLg,
            ),
            child: _buildContent(foregroundColor),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor) {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: foregroundColor,
          strokeWidth: 2,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.prefixIcon != null) ...[
          widget.prefixIcon!,
          const SizedBox(width: AppConstants.spaceSM),
        ],
        Text(
          widget.text,
          style: AppTypography.labelLg.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.suffixIcon != null) ...[
          const SizedBox(width: AppConstants.spaceSM),
          widget.suffixIcon!,
        ],
      ],
    );
  }
}
