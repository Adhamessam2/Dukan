import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'package:Dukan/core/routes/routes.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/views/payment_webview_args.dart';
import 'package:Dukan/features/orders/presentation/views/payment_webview_screen.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_success_dialog.dart';

class MockPlatformNavigationDelegate extends PlatformNavigationDelegate {
  MockPlatformNavigationDelegate(super.params) : super.implementation();

  ProgressCallback? onProgress;
  PageEventCallback? onPageStarted;
  PageEventCallback? onPageFinished;
  WebResourceErrorCallback? onWebResourceError;
  NavigationRequestCallback? onNavigationRequest;
  UrlChangeCallback? onUrlChange;

  HttpResponseErrorCallback? onHttpError;

  @override
  Future<void> setOnProgress(ProgressCallback onProgress) async {
    this.onProgress = onProgress;
  }

  @override
  Future<void> setOnPageStarted(PageEventCallback onPageStarted) async {
    this.onPageStarted = onPageStarted;
  }

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
    this.onPageFinished = onPageFinished;
  }

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {
    this.onWebResourceError = onWebResourceError;
  }

  @override
  Future<void> setOnHttpError(HttpResponseErrorCallback onHttpError) async {
    this.onHttpError = onHttpError;
  }

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {
    this.onNavigationRequest = onNavigationRequest;
  }

  @override
  Future<void> setOnUrlChange(UrlChangeCallback onUrlChange) async {
    this.onUrlChange = onUrlChange;
  }
}

class MockWebViewPlatform extends WebViewPlatform {
  MockPlatformNavigationDelegate? lastDelegate;

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    lastDelegate = MockPlatformNavigationDelegate(params);
    return lastDelegate!;
  }
}

class FakePlatformWebViewController with Fake
    implements PlatformWebViewController {}

class FakeWebViewController with Fake implements WebViewController {
  NavigationDelegate? capturedDelegate;
  int reloadCallCount = 0;
  Uri? loadedUri;
  JavaScriptMode? javaScriptMode;

  @override
  PlatformWebViewController get platform => FakePlatformWebViewController();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    this.javaScriptMode = javaScriptMode;
  }

  @override
  Future<void> setNavigationDelegate(NavigationDelegate delegate) async {
    capturedDelegate = delegate;
  }

  @override
  Future<void> loadRequest(
    Uri uri, {
    LoadRequestMethod method = LoadRequestMethod.get,
    Map<String, String> headers = const <String, String>{},
    Uint8List? body,
  }) async {
    loadedUri = uri;
  }

  @override
  Future<void> reload() async {
    reloadCallCount++;
  }
}

void main() {
  late MockWebViewPlatform mockPlatform;

  setUpAll(() {
    mockPlatform = MockWebViewPlatform();
    WebViewPlatform.instance = mockPlatform;
  });
  final tOrder = OrderEntity(
    id: 8741,
    shippingCity: 'Cairo',
    shippingStreet: 'Tahrir Square',
    shippingBuilding: 'Building 12',
    orderStatus: 'PENDING',
    totalAmount: 199.99,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2026, 9, 22),
  );

  final tArgs = PaymentWebViewArgs(
    url: 'https://accept.paymob.com/api/acceptance/iframes/123456',
    order: tOrder,
  );

  late FakeWebViewController fakeController;

  setUp(() {
    fakeController = FakeWebViewController();
  });

  void setupPortrait(WidgetTester tester) {
    tester.view.physicalSize = const Size(750, 1624);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  void setupLandscape(WidgetTester tester) {
    tester.view.physicalSize = const Size(1624, 750);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget buildTestWidget({
    PaymentWebViewArgs? args,
    FakeWebViewController? controller,
    bool isLandscape = false,
  }) {
    final effectiveArgs = args ?? tArgs;
    final effectiveController = controller ?? fakeController;

    final testRouter = GoRouter(
      initialLocation: Routes.paymentWebView,
      routes: [
        GoRoute(
          path: Routes.paymentWebView,
          builder: (context, state) => PaymentWebViewScreen(
            args: effectiveArgs,
            controller: effectiveController,
            webViewBuilder: (context, c) => const SizedBox(
              key: Key('mock_webview_widget'),
            ),
          ),
        ),
        GoRoute(
          path: Routes.orders,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Orders Screen Target')),
          ),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Home Screen Target')),
          ),
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: isLandscape
          ? AppConstants.designSizeLandscape
          : AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: testRouter,
      ),
    );
  }

  group('PaymentWebViewScreen', () {
    testWidgets('1. renders AppBar with Card Payment and SSL secure badge', (
      tester,
    ) async {
      setupPortrait(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Card Payment'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
      expect(find.text('256-bit SSL'), findsOneWidget);
      expect(find.byType(Tooltip), findsWidgets);
    });

    testWidgets('2. renders LinearProgressIndicator when loading and hides when 100', (
      tester,
    ) async {
      setupPortrait(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      fakeController.capturedDelegate?.onProgress?.call(100);
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets(
      '3. back navigation triggers Exit Confirmation Dialog with Stay and Exit options',
      (tester) async {
        setupPortrait(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final backButton = find.byType(IconButton).first;
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        expect(find.text('Exit Payment?'), findsOneWidget);
        expect(
          find.text(
            'Your order #DK-8741 has been created. If you exit now, you can review and track your order in the Orders tab.',
          ),
          findsOneWidget,
        );
        expect(find.text('Stay'), findsOneWidget);
        expect(find.text('Exit'), findsOneWidget);
      },
    );

    testWidgets(
      '4. tapping Stay closes the dialog and keeps the screen open',
      (tester) async {
        setupPortrait(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();

        expect(find.text('Exit Payment?'), findsOneWidget);

        await tester.tap(find.text('Stay'));
        await tester.pumpAndSettle();

        expect(find.text('Exit Payment?'), findsNothing);
        expect(find.text('Card Payment'), findsOneWidget);
      },
    );

    testWidgets(
      '5. tapping Exit closes dialog and navigates to Routes.orders',
      (tester) async {
        setupPortrait(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Exit'));
        await tester.pumpAndSettle();

        expect(find.text('Orders Screen Target'), findsOneWidget);
      },
    );

    testWidgets(
      '6. error state displays retry button and error description, calling reload on tap',
      (tester) async {
        setupPortrait(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Failed to load payment page'), findsNothing);

        fakeController.capturedDelegate?.onWebResourceError?.call(
          const WebResourceError(
            errorCode: -1,
            description: 'Connection failed. Check network.',
            isForMainFrame: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
        expect(find.text('Failed to load payment page'), findsOneWidget);
        expect(find.text('Connection failed. Check network.'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);

        await tester.tap(find.text('Retry'));
        await tester.pump();

        expect(fakeController.reloadCallCount, 1);
        expect(find.text('Failed to load payment page'), findsNothing);
      },
    );

    testWidgets(
      '6b. HTTP error (status >= 400) displays error screen with status code',
      (tester) async {
        setupPortrait(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        mockPlatform.lastDelegate?.onHttpError?.call(
          HttpResponseError(
            response: WebResourceResponse(
              uri: Uri.parse('https://accept.paymob.com/failed'),
              statusCode: 502,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Failed to load payment page'), findsOneWidget);
        expect(
          find.text('Payment server returned error (502)'),
          findsOneWidget,
        );
      },
    );

    testWidgets('6c. empty payment URL displays error state immediately', (
      tester,
    ) async {
      setupPortrait(tester);
      await tester.pumpWidget(
        buildTestWidget(
          args: PaymentWebViewArgs(
            url: '',
            order: tOrder,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load payment page'), findsOneWidget);
      expect(find.text('Invalid or missing payment URL.'), findsOneWidget);
    });

    testWidgets('7. successful payment URL triggers OrderSuccessDialog', (
      tester,
    ) async {
      setupPortrait(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      fakeController.capturedDelegate?.onPageStarted?.call(
        'https://payment.example.com/callback?success=true&order_id=8741',
      );
      await tester.pumpAndSettle();

      expect(find.byType(OrderSuccessDialog), findsOneWidget);
    });

    testWidgets('8. failed payment URL displays error snackbar', (tester) async {
      setupPortrait(tester);
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      fakeController.capturedDelegate?.onPageStarted?.call(
        'https://payment.example.com/callback?success=false&message=Declined',
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.textContaining('Payment failed'),
        findsOneWidget,
      );
    });

    testWidgets(
      '9. verified in landscape orientation with zero RenderFlex overflow',
      (tester) async {
        setupLandscape(tester);
        await tester.pumpWidget(buildTestWidget(isLandscape: true));
        await tester.pumpAndSettle();

        expect(find.text('Card Payment'), findsOneWidget);
        expect(find.text('256-bit SSL'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Error state in landscape
        fakeController.capturedDelegate?.onWebResourceError?.call(
          const WebResourceError(
            errorCode: -2,
            description: 'Server unavailable',
            isForMainFrame: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Failed to load payment page'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Exit confirmation dialog in landscape
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();

        expect(find.text('Exit Payment?'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      '10. onNavigationRequest prevents success/failure URLs and navigates others',
      (tester) async {
        setupPortrait(tester);
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final delegate = fakeController.capturedDelegate;
        expect(delegate?.onNavigationRequest, isNotNull);

        final normalDecision = await delegate!.onNavigationRequest!(
          const NavigationRequest(
            url: 'https://accept.paymob.com/api/acceptance/post_pay',
            isMainFrame: true,
          ),
        );
        expect(normalDecision, NavigationDecision.navigate);

        final successDecision = await delegate.onNavigationRequest!(
          const NavigationRequest(
            url:
                'https://payment.example.com/callback?success=true&order_id=8741',
            isMainFrame: true,
          ),
        );
        expect(successDecision, NavigationDecision.prevent);
        await tester.pumpAndSettle();
        expect(find.byType(OrderSuccessDialog), findsOneWidget);
      },
    );
  });
}
