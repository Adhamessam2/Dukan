import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../utils/constants.dart';

/// A refined input field conforming to "Warm Architectural Minimalism".
class CustomTextField extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    this.label,
    this.labelWidget,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.autovalidateMode,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelWidget != null) ...[
          labelWidget!,
          const SizedBox(height: AppConstants.spaceSM),
        ] else if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelSm.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spaceSM),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          enabled: enabled,
          readOnly: readOnly,
          onChanged: onChanged,
          onTap: onTap,
          autovalidateMode: autovalidateMode,
          textInputAction: textInputAction,
          style: AppTypography.bodyMd.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: prefixIcon,
            prefixIconConstraints: prefixIconConstraints,
            suffixIcon: suffixIcon,
            suffixIconConstraints: suffixIconConstraints,
            filled: true,
            fillColor: colorScheme.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceMD,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
