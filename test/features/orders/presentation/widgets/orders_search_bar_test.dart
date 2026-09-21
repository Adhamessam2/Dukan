import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_search_bar.dart';

void main() {
  Widget buildTestWidget({
    String initialQuery = '',
    required ValueChanged<String> onQueryChanged,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: OrdersSearchBar(
            initialQuery: initialQuery,
            onQueryChanged: onQueryChanged,
          ),
        ),
      ),
    );
  }

  group('OrdersSearchBar', () {
    testWidgets('renders search input field with hint and prefix icon', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(onQueryChanged: (_) {}));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search orders by ID or product...'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('calls onQueryChanged when text is entered', (tester) async {
      String currentQuery = '';
      await tester.pumpWidget(
        buildTestWidget(onQueryChanged: (query) => currentQuery = query),
      );

      await tester.enterText(find.byType(TextField), '8740');
      await tester.pump(const Duration(milliseconds: 300));

      expect(currentQuery, '8740');
      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);
    });

    testWidgets('tapping clear button clears text and dispatches empty query', (
      tester,
    ) async {
      String currentQuery = 'initial';
      await tester.pumpWidget(
        buildTestWidget(
          initialQuery: 'initial',
          onQueryChanged: (query) => currentQuery = query,
        ),
      );

      expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear_rounded));
      await tester.pump();

      expect(currentQuery, '');
      expect(find.text('initial'), findsNothing);
    });
  });
}
