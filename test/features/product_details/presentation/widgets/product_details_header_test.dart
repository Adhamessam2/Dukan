import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/product_details/presentation/widgets/product_details_header.dart';

void main() {
  Widget buildTestWidget({
    String title = 'Product Details',
    VoidCallback? onBackTap,
    bool showBackButton = true,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ProductDetailsHeader(
            title: title,
            onBackTap: onBackTap,
            showBackButton: showBackButton,
          ),
        ),
      ),
    );
  }

  testWidgets('renders brand logo D and title text', (tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('D'), findsOneWidget);
    expect(find.text('Product Details'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
  });

  testWidgets('custom title is rendered properly', (tester) async {
    await tester.pumpWidget(buildTestWidget(title: 'Custom Title'));

    expect(find.text('Custom Title'), findsOneWidget);
  });

  testWidgets('tapping back button triggers onBackTap callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(buildTestWidget(onBackTap: () => tapped = true));

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('hides back button when showBackButton is false', (tester) async {
    await tester.pumpWidget(buildTestWidget(showBackButton: false));

    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    expect(find.text('D'), findsOneWidget);
    expect(find.text('Product Details'), findsOneWidget);
  });
}
