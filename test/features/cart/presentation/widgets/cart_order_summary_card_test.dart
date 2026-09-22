import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_order_summary_card.dart';

void main() {
  Widget buildTestWidget({required double totalPrice, bool isCompact = false}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: CartOrderSummaryCard(
            totalPrice: totalPrice,
            isCompact: isCompact,
          ),
        ),
      ),
    );
  }

  group('CartOrderSummaryCard', () {
    testWidgets('renders standard full view when isCompact is false', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(totalPrice: 56.0));
      await tester.pumpAndSettle();

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('\$56.00'), findsNWidgets(2)); // subtotal and total
      expect(find.text('Standard Shipping'), findsOneWidget);
      expect(find.text('FREE'), findsOneWidget);
      expect(find.text('Estimated Tax'), findsOneWidget);
      expect(find.text('Included'), findsOneWidget);
      expect(find.text('Includes local sales tax'), findsOneWidget);
      expect(find.text('Total Amount'), findsOneWidget);
    });

    testWidgets('renders compact view when isCompact is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(totalPrice: 56.0, isCompact: true),
      );
      await tester.pumpAndSettle();

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('\$56.00'), findsNWidgets(2));
      // In compact mode, Shipping & Tax are collapsed into a single row
      expect(find.text('Shipping & Tax'), findsOneWidget);
      expect(find.text('FREE • Incl.'), findsOneWidget);
      // Secondary lines are stripped out
      expect(find.text('Standard Shipping'), findsNothing);
      expect(find.text('Estimated Tax'), findsNothing);
      expect(find.text('Includes local sales tax'), findsNothing);
      expect(find.text('Total Amount'), findsOneWidget);
      // Tooltip is present
      expect(find.byType(Tooltip), findsOneWidget);
    });
  });
}
