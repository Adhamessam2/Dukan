import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_empty_view.dart';

void main() {
  Widget buildTestWidget({
    String title = 'No Orders Found',
    String subtitle = 'Browse our collection and place your first order.',
    VoidCallback? onStartShoppingPressed,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: OrdersEmptyView(
            title: title,
            subtitle: subtitle,
            onStartShoppingPressed: onStartShoppingPressed,
          ),
        ),
      ),
    );
  }

  group('OrdersEmptyView', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('No Orders Found'), findsOneWidget);
      expect(
        find.text('Browse our collection and place your first order.'),
        findsOneWidget,
      );
    });

    testWidgets('renders CTA button when callback is provided', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        buildTestWidget(onStartShoppingPressed: () => pressed = true),
      );

      expect(find.text('Start Shopping'), findsOneWidget);
      await tester.tap(find.text('Start Shopping'));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('renders custom actionLabel and actionIcon', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: OrdersEmptyView(
                title: 'Unable to Load Orders',
                subtitle: 'Failed to load',
                actionLabel: 'Try Again',
                actionIcon: const Icon(Icons.refresh_rounded),
                onStartShoppingPressed: () => pressed = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
