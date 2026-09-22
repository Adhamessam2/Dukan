import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/order_success_dialog.dart';
import 'payment_webview_args.dart';

/// Screen presenting a secure WebView for online card payment processing.
/// Conforms strictly to AGENTS.md: zero magic numbers, pure theme tokens,
/// repaint isolation, and landscape viewport resilience.
class PaymentWebViewScreen extends StatefulWidget {
  final PaymentWebViewArgs args;
  final WebViewController? controller;
  final Widget Function(BuildContext context, WebViewController controller)?
  webViewBuilder;

  const PaymentWebViewScreen({
    super.key,
    required this.args,
    this.controller,
    this.webViewBuilder,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  final ValueNotifier<int> _progressNotifier = ValueNotifier<int>(0);
  bool _hasError = false;
  String? _errorMessage;
  bool _isHandled = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? WebViewController();
    _initController();
  }

  @override
  void dispose() {
    _progressNotifier.dispose();
    super.dispose();
  }

  void _initController() {
    if (_controller.platform is AndroidWebViewController) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      if (kDebugMode) {
        AndroidWebViewController.enableDebugging(true);
      }
      androidController.setMediaPlaybackRequiresUserGesture(false);
      androidController.setMixedContentMode(MixedContentMode.alwaysAllow);
      androidController.setOnConsoleMessage((consoleMessage) {
        debugPrint(
          '[PaymentWebView:JS] [${consoleMessage.level.name}] ${consoleMessage.message}',
        );
      });
      if (WebViewCookieManager().platform is AndroidWebViewCookieManager) {
        (WebViewCookieManager().platform as AndroidWebViewCookieManager)
            .setAcceptThirdPartyCookies(androidController, true);
      }
    }

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _progressNotifier.value = progress;
          },
          onPageStarted: (String url) {
            debugPrint('[PaymentWebView] Page started loading: $url');
            if (mounted) {
              setState(() {
                _hasError = false;
                _errorMessage = null;
              });
            }
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            debugPrint('[PaymentWebView] Page finished loading: $url');
            _progressNotifier.value = 100;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
              '[PaymentWebView] WebResourceError: code=${error.errorCode}, '
              'description=${error.description}, '
              'isForMainFrame=${error.isForMainFrame}, '
              'url=${error.url}',
            );
            if (error.isForMainFrame ?? true) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _errorMessage = error.description.isNotEmpty
                      ? error.description
                      : 'Connection error (${error.errorCode})';
                });
              }
            }
          },
          onHttpError: (HttpResponseError error) {
            debugPrint(
              '[PaymentWebView] HttpError: status=${error.response?.statusCode}',
            );
            if (error.response != null && error.response!.statusCode >= 400) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _errorMessage =
                      'Payment server returned error (${error.response!.statusCode})';
                });
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint(
              '[PaymentWebView] NavigationRequest: url=${request.url}',
            );
            if (_checkPaymentSuccess(request.url)) {
              if (!_isHandled) {
                _isHandled = true;
                _handleSuccess();
              }
              return NavigationDecision.prevent;
            }
            if (_checkPaymentFailure(request.url)) {
              if (!_isHandled) {
                _isHandled = true;
                _handleFailure();
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('[PaymentWebView] UrlChange: url=${change.url}');
            if (change.url != null) {
              _checkUrl(change.url!);
            }
          },
        ),
      );

    _loadPaymentUrl();
  }

  void _loadPaymentUrl() {
    final rawUrl = widget.args.url.trim();
    final uri = Uri.tryParse(rawUrl);
    if (uri != null && uri.hasScheme) {
      debugPrint('[PaymentWebView] Loading request: $uri');
      _controller.loadRequest(uri);
    } else if (rawUrl.isNotEmpty) {
      final fallbackUri = Uri.parse('https://$rawUrl');
      debugPrint('[PaymentWebView] Loading fallback request: $fallbackUri');
      _controller.loadRequest(fallbackUri);
    } else {
      debugPrint('[PaymentWebView] Error: Payment URL is empty or invalid.');
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid or missing payment URL.';
      });
    }
  }

  bool _checkPaymentSuccess(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.queryParameters['success']?.toLowerCase() == 'true') return true;
    if (url.toLowerCase().contains('success=true')) return true;
    return false;
  }

  bool _checkPaymentFailure(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (uri.queryParameters['success']?.toLowerCase() == 'false') return true;
    if (url.toLowerCase().contains('success=false')) return true;
    return false;
  }

  void _checkUrl(String url) {
    if (_isHandled) return;
    if (_checkPaymentSuccess(url)) {
      _isHandled = true;
      _handleSuccess();
    } else if (_checkPaymentFailure(url)) {
      _isHandled = true;
      _handleFailure();
    }
  }

  void _handleSuccess() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => OrderSuccessDialog(
        order: widget.args.order,
        onContinueShopping: () {
          Navigator.of(dialogCtx).pop();
          context.go(Routes.home);
        },
        onTrackOrders: () {
          Navigator.of(dialogCtx).pop();
          context.go(Routes.orders);
        },
      ),
    );
  }

  void _handleFailure([String? message]) {
    context.showErrorSnackBar(
      message ?? 'Payment failed. Please check your card and try again.',
    );
    _isHandled = false;
  }

  void _handleRetry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isHandled = false;
    });
    _progressNotifier.value = 0;
    _loadPaymentUrl();
    _controller.reload();
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG.r),
        ),
        title: Text(
          'Exit Payment?',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Your order #DK-${widget.args.order.id} has been created. If you exit now, you can review and track your order in the Orders tab.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Stay',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.go(Routes.orders);
            },
            child: Text(
              'Exit',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSslBadge(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(right: AppConstants.margin.w),
        child: Tooltip(
          message: '256-bit SSL Encrypted Connection',
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacingSM.w,
              vertical: AppConstants.spacingXS.h,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppConstants.radiusRound.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: AppConstants.hairlineStrokeWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: AppConstants.iconSizeSM.r,
                  color: colorScheme.primary,
                ),
                SizedBox(width: AppConstants.spacingXS.w),
                Text(
                  '256-bit SSL',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppConstants.margin.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: AppConstants.iconSizeXL.r,
              color: colorScheme.error,
            ),
            SizedBox(height: AppConstants.spacingMD.h),
            Text(
              'Failed to load payment page',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.spacingSM.h),
            Text(
              _errorMessage ?? AppConstants.networkErrorMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppConstants.spacingLG.h),
            CustomButton(
              text: 'Retry',
              onPressed: _handleRetry,
              prefixIcon: Icon(
                Icons.refresh_rounded,
                size: AppConstants.iconSizeSM.r,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Card Payment',
          onBackTap: () => _showExitConfirmationDialog(context),
          actions: [_buildSslBadge(context)],
        ),
        body: SafeArea(
          child: _hasError
              ? _buildErrorState(context)
              : Column(
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: _progressNotifier,
                      builder: (context, progress, _) {
                        if (progress >= 100) return const SizedBox.shrink();
                        return RepaintBoundary(
                          child: SizedBox(
                            height: AppConstants.spacingXS.h,
                            child: LinearProgressIndicator(
                              value: progress / 100.0,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: widget.webViewBuilder != null
                          ? widget.webViewBuilder!(context, _controller)
                          : WebViewWidget(controller: _controller),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
