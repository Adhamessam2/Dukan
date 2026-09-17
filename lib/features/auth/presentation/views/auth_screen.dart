import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../cubit/sign_up_cubit.dart';
import '../cubit/sign_up_state.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_segmented_switcher.dart';
import '../widgets/sign_in_form.dart';
import '../widgets/sign_up_form.dart';

enum AuthTab { signIn, signUp }

/// Unified, responsive AuthScreen conforming to "Warm Architectural Minimalism".
class AuthScreen extends StatefulWidget {
  final AuthTab initialTab;

  const AuthScreen({super.key, this.initialTab = AuthTab.signIn});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthTab _currentTab;
  late final TextEditingController _sharedEmailController;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
    _sharedEmailController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant AuthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      setState(() => _currentTab = widget.initialTab);
    }
  }

  @override
  void dispose() {
    _sharedEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        // Login Cubit Listener for Side Effects
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.showSuccessSnackBar(state.message);
              if (mounted) {
                context.go(Routes.home);
              }
            } else if (state is LoginFailure) {
              context.showErrorSnackBar(state.errorMessage);
            }
          },
        ),

        // Sign Up Cubit Listener for Side Effects
        BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              context.showSuccessSnackBar(state.message);
              setState(() {
                _currentTab = AuthTab.signIn;
              });
            } else if (state is SignUpFailure) {
              context.showErrorSnackBar(state.errorMessage);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.hideKeyboard(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMD.w,
                vertical: AppConstants.spaceMD.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand Mascot & Header
                  const RepaintBoundary(child: AuthHeader()),
                  SizedBox(height: AppConstants.spaceLG.h),

                  // Segmented Switcher Tab
                  AuthSegmentedSwitcher(
                    selectedIndex: _currentTab == AuthTab.signIn ? 0 : 1,
                    onTabChanged: (index) {
                      setState(() {
                        _currentTab = index == 0
                            ? AuthTab.signIn
                            : AuthTab.signUp;
                      });
                    },
                  ),
                  SizedBox(height: AppConstants.spaceLG.h),

                  // Animated Form Transition (AnimatedCrossFade internally handles AnimatedSize)
                  AnimatedCrossFade(
                    duration: AppConstants.mediumAnimationDuration,
                    crossFadeState: _currentTab == AuthTab.signIn
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: SignInForm(
                      emailController: _sharedEmailController,
                    ),
                    secondChild: SignUpForm(
                      emailController: _sharedEmailController,
                    ),
                  ),
                  SizedBox(height: AppConstants.spaceLG.h),

                  // Trust & Policy Footer
                  const AuthFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
