import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/login_params.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

/// Sign In Form matching Figma specifications.
class SignInForm extends StatefulWidget {
  final TextEditingController? emailController;

  const SignInForm({super.key, this.emailController});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = widget.emailController ?? TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    if (widget.emailController == null) {
      _emailController.dispose();
    }
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        LoginParams(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email Field
          CustomTextField(
            label: 'Email Address',
            hint: 'alex.chen@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              color: colorScheme.secondary,
              size: AppConstants.controlSize.w,
            ),
            validator: Validators.email,
          ),
          SizedBox(height: AppConstants.spaceMD.h),

          // Password Field with "Forgot password?" Link
          CustomTextField(
            labelWidget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: AppTypography.labelSm.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.showSnackBar('Forgot password link tapped');
                  },
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.labelSm.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            hint: '••••••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: colorScheme.secondary,
              size: AppConstants.controlSize.w,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.secondary,
                size: AppConstants.controlSize.w,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            validator: (value) =>
                Validators.required(value, fieldName: 'Password'),
          ),
          SizedBox(height: AppConstants.spaceLG.h),

          // Primary CTA Button with Granular Rebuild via BlocSelector
          BlocSelector<LoginCubit, LoginState, bool>(
            selector: (state) => state is LoginLoading,
            builder: (context, isLoading) {
              return CustomButton(
                text: 'Sign In to Dukaan',
                isLoading: isLoading,
                color: colorScheme.primaryContainer,
                textColor: colorScheme.onPrimaryContainer,
                suffixIcon: Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 18.w,
                ),
                onPressed: isLoading ? null : _submit,
              );
            },
          ),
        ],
      ),
    );
  }
}
