import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/home/presentation/widgets/home_bottom_nav_bar.dart';

void main() {
  Widget buildTestWidget({
    int selectedIndex = 0,
    int cartItemCount = 0,
    ValueChanged<int>? onIndexChanged,
  }) {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          bottomNavigationBar: HomeBottomNavBar(
            selectedIndex: selectedIndex,
            cartItemCount: cartItemCount,
            onIndexChanged: onIndexChanged,
          ),
        ),
      ),
    );
  }

  group('HomeBottomNavBar', () {
    testWidgets('renders exactly 3 navigation items: Home, Cart, and Orders', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Browse'), findsNothing);

      expect(find.byIcon(Icons.home_filled), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
      expect(find.byIcon(Icons.explore_outlined), findsNothing);
    });

    testWidgets('triggers onIndexChanged with indices 0, 1, 2', (tester) async {
      final tappedIndices = <int>[];

      await tester.pumpWidget(
        buildTestWidget(onIndexChanged: (index) => tappedIndices.add(index)),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(tappedIndices, [0]);

      await tester.tap(find.text('Cart'));
      await tester.pumpAndSettle();
      expect(tappedIndices, [0, 1]);

      await tester.tap(find.text('Orders'));
      await tester.pumpAndSettle();
      expect(tappedIndices, [0, 1, 2]);
    });

    testWidgets('displays badge on Cart tab when cartItemCount > 0', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(cartItemCount: 3));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });
  });
}
