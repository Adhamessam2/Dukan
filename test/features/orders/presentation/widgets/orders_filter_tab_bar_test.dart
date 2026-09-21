import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/presentation/cubit/orders_state.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_filter_tab_bar.dart';

void main() {
  Widget buildTestWidget({
    required OrdersFilterTab selectedTab,
    required ValueChanged<OrdersFilterTab> onTabChanged,
    int totalCount = 3,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: OrdersFilterTabBar(
              selectedTab: selectedTab,
              onTabChanged: onTabChanged,
              totalCount: totalCount,
            ),
          ),
        ),
      ),
    );
  }

  group('OrdersFilterTabBar', () {
    testWidgets('renders all six tabs and badge count on All tab',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          selectedTab: OrdersFilterTab.all,
          onTabChanged: (_) {},
          totalCount: 5,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Processing'), findsOneWidget);
      expect(find.text('Shipped'), findsOneWidget);
      expect(find.text('Delivered'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('tapping Pending tab triggers onTabChanged callback',
        (tester) async {
      OrdersFilterTab? selected;
      await tester.pumpWidget(
        buildTestWidget(
          selectedTab: OrdersFilterTab.all,
          onTabChanged: (tab) => selected = tab,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Pending'));
      await tester.tap(find.text('Pending'));
      await tester.pump();

      expect(selected, equals(OrdersFilterTab.pending));
    });

    testWidgets('tapping Delivered tab triggers onTabChanged callback',
        (tester) async {
      OrdersFilterTab? selected;
      await tester.pumpWidget(
        buildTestWidget(
          selectedTab: OrdersFilterTab.all,
          onTabChanged: (tab) => selected = tab,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Delivered'));
      await tester.tap(find.text('Delivered'));
      await tester.pump();

      expect(selected, equals(OrdersFilterTab.delivered));
    });

    testWidgets('tapping Cancelled tab triggers onTabChanged callback',
        (tester) async {
      OrdersFilterTab? selected;
      await tester.pumpWidget(
        buildTestWidget(
          selectedTab: OrdersFilterTab.all,
          onTabChanged: (tab) => selected = tab,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cancelled'));
      await tester.tap(find.text('Cancelled'));
      await tester.pump();

      expect(selected, equals(OrdersFilterTab.cancelled));
    });
  });
}
