import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/presentation/widgets/orders_activity_header.dart';

void main() {
  Widget buildTestWidget({required int activeShipmentsCount}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: OrdersActivityHeader(
            activeShipmentsCount: activeShipmentsCount,
          ),
        ),
      ),
    );
  }

  group('OrdersActivityHeader', () {
    testWidgets('renders ACTIVITY label and My Orders headline', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(activeShipmentsCount: 0));

      expect(find.text('ACTIVITY'), findsOneWidget);
      expect(find.text('My Orders'), findsOneWidget);
      expect(find.textContaining('active shipment'), findsNothing);
    });

    testWidgets('renders active shipment pill when count > 0', (tester) async {
      await tester.pumpWidget(buildTestWidget(activeShipmentsCount: 1));

      expect(find.text('1 active shipment'), findsOneWidget);
    });

    testWidgets('renders pluralized text for multiple active shipments', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(activeShipmentsCount: 3));

      expect(find.text('3 active shipments'), findsOneWidget);
    });
  });
}
