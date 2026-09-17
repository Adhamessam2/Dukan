import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/sign_up_params.dart';
import '../cubit/sign_up_cubit.dart';
import '../cubit/sign_up_state.dart';

/// Sign Up (Create Account) Form matching Figma specifications.
class SignUpForm extends StatefulWidget {
  final TextEditingController? emailController;

  const SignUpForm({
    super.key,
    this.emailController,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final String _countryCode = '+1';

  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = widget.emailController ?? TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    if (widget.emailController == null) {
      _emailController.dispose();
    }
    _phoneController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _selectedBirthDate ?? DateTime(2000, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 10, now.month, now.day),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      _selectedBirthDate = pickedDate;
      final formattedMonth = pickedDate.month.toString().padLeft(2, '0');
      final formattedDay = pickedDate.day.toString().padLeft(2, '0');
      _dobController.text = '${pickedDate.year}-$formattedMonth-$formattedDay';
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final cleanPhone = _phoneController.text.trim().replaceAll(RegExp(r'[\s()-]'), '');
      context.read<SignUpCubit>().signUp(
            SignUpParams(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              phoneNumber: '$_countryCode$cleanPhone',
              birthDate: _selectedBirthDate ?? DateTime.tryParse(_dobController.text) ?? DateTime(2000, 1, 1),
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
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
          // 1. Username Field
          CustomTextField(
            label: 'Username',
            hint: 'alexchen',
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: Icon(
              Icons.person_outline_rounded,
              color: colorScheme.secondary,
              size: AppConstants.controlSize.w,
            ),
            validator: (val) => Validators.minLength(
              val,
              AppConstants.minUsernameLength,
              fieldName: 'Username',
            ),
          ),
          SizedBox(height: 14.h),

          // 2. Email Address Field
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
          SizedBox(height: 14.h),

          // 3. Phone Number Field with Country Badge
          CustomTextField(
            label: 'Phone Number',
            hint: '(555) 382-9102',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIconConstraints: BoxConstraints(
              minWidth: 80.w,
              minHeight: AppConstants.inputHeight.h,
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 12.w),
                Text(
                  '🇺🇸',
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(width: AppConstants.spaceXS.w),
                Text(
                  '+1',
                  style: AppTypography.labelMd.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: colorScheme.secondary,
                  size: AppConstants.iconSizeSM.w,
                ),
                Container(
                  height: AppConstants.controlSize.h,
                  width: AppConstants.hairlineStrokeWidth,
                  margin: EdgeInsets.only(left: 6.w, right: 8.w),
                  color: colorScheme.outlineVariant,
                ),
              ],
            ),
            validator: Validators.phone,
          ),
          SizedBox(height: 14.h),

          // 4. Date of Birth Field (Native DatePicker)
          CustomTextField(
            label: 'Date of Birth',
            hint: 'YYYY-MM-DD',
            controller: _dobController,
            readOnly: true,
            onTap: _selectDateOfBirth,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: colorScheme.secondary,
              size: 18.w,
            ),
            validator: (val) => Validators.required(val, fieldName: 'Date of Birth'),
          ),
          SizedBox(height: 14.h),

          // 5. Password Field
          CustomTextField(
            label: 'Password',
            hint: '••••••••••••',
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
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
            validator: Validators.password,
          ),
          SizedBox(height: 14.h),

          // 6. Confirm Password Field
          CustomTextField(
            label: 'Confirm Password',
            hint: '••••••••••••',
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: colorScheme.secondary,
              size: AppConstants.controlSize.w,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colorScheme.secondary,
                size: AppConstants.controlSize.w,
              ),
              onPressed: () {
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
            validator: (val) => Validators.confirmPassword(val, _passwordController.text),
          ),
          SizedBox(height: 6.h),

          // Micro-copy Helper
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.spaceXS.w),
            child: Text(
              'Must be at least ${AppConstants.minPasswordLength} characters with 1 number and a symbol.',
              style: AppTypography.bodySm.copyWith(
                color: colorScheme.secondary,
                fontSize: 11.sp,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Primary CTA Button with Granular Rebuild via BlocSelector
          BlocSelector<SignUpCubit, SignUpState, bool>(
            selector: (state) => state is SignUpLoading,
            builder: (context, isLoading) {
              return CustomButton(
                text: 'Create Account',
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
