import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/core/widgets/custom_app_bar.dart';

void main() {
  Widget buildTestableWidget(
    Widget child, {
    Orientation orientation = Orientation.portrait,
  }) {
    return ScreenUtilInit(
      designSize: orientation == Orientation.landscape
          ? AppConstants.designSizeLandscape
          : AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: child as PreferredSizeWidget,
          body: const SizedBox.shrink(),
        ),
      ),
    );
  }

  void setupPortrait(WidgetTester tester) {
    tester.view.physicalSize = const Size(375 * 2, 812 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  group('CustomAppBar Widget Tests', () {
    testWidgets(
      'renders title and back button by default, and triggers onBackTap',
      (tester) async {
        setupPortrait(tester);
        bool backTapped = false;

        await tester.pumpWidget(
          buildTestableWidget(
            CustomAppBar(title: 'Checkout', onBackTap: () => backTapped = true),
          ),
        );

        expect(find.text('Checkout'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);

        await tester.tap(find.byType(IconButton));
        expect(backTapped, isTrue);
      },
    );

    testWidgets('triggers Navigator.maybePop when onBackTap is null', (
      tester,
    ) async {
      setupPortrait(tester);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: AppConstants.designSizePortrait,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) => MaterialApp(
            theme: AppTheme.lightTheme,
            home: Builder(
              builder: (ctx) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).push(
                      MaterialPageRoute(
                        builder: (_) => const Scaffold(
                          appBar: CustomAppBar(title: 'Second Screen'),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Second Screen'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Second Screen'), findsNothing);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('hides back button when showBackButton is false', (
      tester,
    ) async {
      setupPortrait(tester);

      await tester.pumpWidget(
        buildTestableWidget(
          const CustomAppBar(title: 'No Back Button', showBackButton: false),
        ),
      );

      expect(find.text('No Back Button'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('renders subtitle and actions when provided', (tester) async {
      setupPortrait(tester);

      await tester.pumpWidget(
        buildTestableWidget(
          const CustomAppBar(
            title: 'Order Review',
            subtitle: 'Step 2 of 2',
            actions: [Icon(Icons.help_outline), Icon(Icons.more_vert)],
          ),
        ),
      );

      expect(find.text('Order Review'), findsOneWidget);
      expect(find.text('Step 2 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders custom leading widget when provided', (tester) async {
      setupPortrait(tester);

      await tester.pumpWidget(
        buildTestableWidget(
          const CustomAppBar(
            title: 'Branded Header',
            showBackButton: false,
            leading: Icon(Icons.storefront),
          ),
        ),
      );

      expect(find.text('Branded Header'), findsOneWidget);
      expect(find.byIcon(Icons.storefront), findsOneWidget);
    });

    testWidgets(
      'is wrapped in RepaintBoundary and preferredSize matches spec',
      (tester) async {
        setupPortrait(tester);

        const appBar = CustomAppBar(title: 'Test Bar');
        await tester.pumpWidget(buildTestableWidget(appBar));

        expect(find.byType(RepaintBoundary), findsWidgets);
        expect(
          appBar.preferredSize.height,
          AppConstants.headerHeight.h.clamp(
            AppConstants.minHeaderHeight,
            AppConstants.maxHeaderHeight,
          ),
        );
      },
    );

    testWidgets('renders without overflow in landscape orientation', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1624, 750);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        buildTestableWidget(
          const CustomAppBar(
            title: 'Checkout',
            subtitle: 'Step 2 of 2',
            actions: [Icon(Icons.help_outline)],
          ),
          orientation: Orientation.landscape,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Step 2 of 2'), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });
  });
}
