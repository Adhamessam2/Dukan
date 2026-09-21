import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_details_bottom_bar.dart';

void main() {
  Widget buildTestWidget({
    VoidCallback? onReorderAllPressed,
    VoidCallback? onNeedHelpPressed,
    bool isReordering = false,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          bottomNavigationBar: OrderDetailsBottomBar(
            onReorderAllPressed: onReorderAllPressed,
            onNeedHelpPressed: onNeedHelpPressed,
            isReordering: isReordering,
          ),
        ),
      ),
    );
  }

  group('OrderDetailsBottomBar', () {
    testWidgets('renders Reorder All Items button and Need Help link', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Reorder All Items'), findsOneWidget);
      expect(find.text('Need Help with this Order?'), findsOneWidget);
      expect(find.byIcon(Icons.replay_rounded), findsOneWidget);
      expect(find.byIcon(Icons.headset_mic_outlined), findsOneWidget);
    });

    testWidgets('shows loading spinner when isReordering is true', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(isReordering: true));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('triggers callbacks on tap', (tester) async {
      bool reorderTapped = false;
      bool helpTapped = false;

      await tester.pumpWidget(
        buildTestWidget(
          onReorderAllPressed: () => reorderTapped = true,
          onNeedHelpPressed: () => helpTapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reorder All Items'));
      await tester.pump();
      expect(reorderTapped, isTrue);

      await tester.tap(find.text('Need Help with this Order?'));
      await tester.pump();
      expect(helpTapped, isTrue);
    });
  });
}
