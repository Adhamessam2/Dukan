import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/auth/presentation/widgets/auth_segmented_switcher.dart';

void main() {
  testWidgets('AuthSegmentedSwitcher renders both tabs and responds to taps', (tester) async {
    int currentTab = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => AuthSegmentedSwitcher(
                selectedIndex: currentTab,
                onTabChanged: (index) => setState(() => currentTab = index),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(currentTab, 1);

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(currentTab, 0);
  });
}
