import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/orders/presentation/widgets/shipping_information_card.dart';

void main() {
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController streetController;
  late TextEditingController buildingController;
  late TextEditingController cityController;
  late GlobalKey<FormState> formKey;

  setUp(() {
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    streetController = TextEditingController();
    buildingController = TextEditingController();
    cityController = TextEditingController();
    formKey = GlobalKey<FormState>();
  });

  tearDown(() {
    fullNameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    buildingController.dispose();
    cityController.dispose();
  });

  Widget buildTestWidget() {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ShippingInformationCard(
                fullNameController: fullNameController,
                phoneController: phoneController,
                streetController: streetController,
                buildingController: buildingController,
                cityController: cityController,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders section title, delivery icon, and all 5 input fields', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Shipping Information'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Street'), findsOneWidget);
    expect(find.text('Building / Apartment Number'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
  });

  testWidgets('validates required fields: street, building, city', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();

    expect(find.text('Street address is required'), findsOneWidget);
    expect(find.text('Building / Apartment is required'), findsOneWidget);
    expect(find.text('City is required'), findsOneWidget);

    streetController.text = 'Main Street 123';
    buildingController.text = 'Bldg 4A';
    cityController.text = 'Cairo';

    expect(formKey.currentState!.validate(), isTrue);
  });
}
