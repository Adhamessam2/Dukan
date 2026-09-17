import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';

/// Trust & Policy Footer displaying interactive links to Terms and Privacy Policy.
class AuthFooter extends StatefulWidget {
  const AuthFooter({super.key});

  @override
  State<AuthFooter> createState() => _AuthFooterState();
}

class _AuthFooterState extends State<AuthFooter> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.showSnackBar('Terms of Service agreement');
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.showSnackBar('Privacy Policy agreement');
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spaceMD.w,
        vertical: AppConstants.spaceSM.h,
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTypography.bodySm.copyWith(
              color: colorScheme.secondary,
              height: 1.6,
            ),
            children: [
              const TextSpan(text: 'By signing up, you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                recognizer: _termsRecognizer,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' and \n'),
              TextSpan(
                text: 'Privacy Policy',
                recognizer: _privacyRecognizer,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
    );
  }
}
