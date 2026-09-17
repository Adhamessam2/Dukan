import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/utils/extensions.dart';

void main() {
  testWidgets('showSnackBar, showErrorSnackBar, showSuccessSnackBar display floating snackbars without assertion error', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => context.showSnackBar('Test Normal SnackBar'),
                    child: const Text('Show Normal'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showErrorSnackBar('Test Error SnackBar'),
                    child: const Text('Show Error'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.showSuccessSnackBar('Test Success SnackBar'),
                    child: const Text('Show Success'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Test normal SnackBar
    await tester.tap(find.text('Show Normal'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.text('Test Normal SnackBar'), findsOneWidget);

    // Dismiss by waiting duration and animation
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Test error SnackBar
    await tester.tap(find.text('Show Error'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.text('Test Error SnackBar'), findsOneWidget);

    // Dismiss
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Test success SnackBar
    await tester.tap(find.text('Show Success'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.text('Test Success SnackBar'), findsOneWidget);
  });
}
