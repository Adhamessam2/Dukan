import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/create_order_use_case.dart';
import 'package:Dukan/features/orders/presentation/cubit/checkout_cubit.dart';
import 'package:Dukan/features/orders/presentation/cubit/checkout_state.dart';

class MockCreateOrderUseCase implements CreateOrderUseCase {
  CreateOrderParams? capturedParams;
  Either<Failure, OrderEntity>? resultToReturn;

  @override
  OrdersRepository get repository => throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    capturedParams = params;
    return resultToReturn!;
  }
}

void main() {
  late CheckoutCubit cubit;
  late MockCreateOrderUseCase mockCreateOrderUseCase;

  final tOrder = OrderEntity(
    id: 42,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Tahrir',
    shippingBuilding: '10',
    orderStatus: 'PENDING',
    totalAmount: 250.0,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2026, 9, 21),
  );

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    cubit = CheckoutCubit(createOrderUseCase: mockCreateOrderUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('CheckoutState', () {
    test('initial state has correct default values', () {
      const state = CheckoutState();
      expect(state.status, CheckoutStatus.initial);
      expect(state.selectedPaymentMethod, PaymentMethod.cash);
      expect(state.createdOrder, isNull);
      expect(state.errorMessage, isNull);
    });

    test('supports value equality', () {
      expect(const CheckoutState(), const CheckoutState());
      expect(
        CheckoutState(
          status: CheckoutStatus.success,
          selectedPaymentMethod: PaymentMethod.creditCard,
          createdOrder: tOrder,
          errorMessage: 'some error',
        ),
        CheckoutState(
          status: CheckoutStatus.success,
          selectedPaymentMethod: PaymentMethod.creditCard,
          createdOrder: tOrder,
          errorMessage: 'some error',
        ),
      );
    });

    test('copyWith copies and overrides properties correctly', () {
      const initial = CheckoutState();
      final updated = initial.copyWith(
        status: CheckoutStatus.submitting,
        selectedPaymentMethod: PaymentMethod.creditCard,
        createdOrder: tOrder,
        errorMessage: 'error',
      );

      expect(updated.status, CheckoutStatus.submitting);
      expect(updated.selectedPaymentMethod, PaymentMethod.creditCard);
      expect(updated.createdOrder, tOrder);
      expect(updated.errorMessage, 'error');

      final partiallyUpdated = updated.copyWith(status: CheckoutStatus.success);
      expect(partiallyUpdated.status, CheckoutStatus.success);
      expect(partiallyUpdated.selectedPaymentMethod, PaymentMethod.creditCard);
      expect(partiallyUpdated.createdOrder, tOrder);
      expect(partiallyUpdated.errorMessage, 'error');
    });

    test('props contains all fields', () {
      final state = CheckoutState(
        status: CheckoutStatus.failure,
        selectedPaymentMethod: PaymentMethod.cash,
        createdOrder: tOrder,
        errorMessage: 'fail',
      );

      expect(state.props, [
        CheckoutStatus.failure,
        PaymentMethod.cash,
        tOrder,
        'fail',
      ]);
    });
  });

  group('CheckoutCubit', () {
    test('initial state should be CheckoutState with initial status', () {
      expect(cubit.state, const CheckoutState());
      expect(cubit.state.status, CheckoutStatus.initial);
      expect(cubit.state.selectedPaymentMethod, PaymentMethod.cash);
    });

    group('selectPaymentMethod', () {
      test('emits state with updated selectedPaymentMethod', () {
        expect(cubit.state.selectedPaymentMethod, PaymentMethod.cash);

        cubit.selectPaymentMethod(PaymentMethod.creditCard);

        expect(cubit.state.selectedPaymentMethod, PaymentMethod.creditCard);
      });
    });

    group('submitOrder', () {
      test(
        'emits [submitting, success] and calls usecase with trimmed params when successful',
        () async {
          mockCreateOrderUseCase.resultToReturn = Right(tOrder);

          final expectedStates = [
            const CheckoutState(status: CheckoutStatus.submitting),
            CheckoutState(status: CheckoutStatus.success, createdOrder: tOrder),
          ];

          final expectation = expectLater(
            cubit.stream,
            emitsInOrder(expectedStates),
          );

          await cubit.submitOrder(
            city: '  Cairo  ',
            street: '  Tahrir  ',
            building: '  10  ',
          );

          await expectation;

          expect(mockCreateOrderUseCase.capturedParams, isNotNull);
          expect(
            mockCreateOrderUseCase.capturedParams!.address,
            const ShippingAddressEntity(
              city: 'Cairo',
              street: 'Tahrir',
              building: '10',
            ),
          );
          expect(
            mockCreateOrderUseCase.capturedParams!.paymentMethod,
            PaymentMethod.cash,
          );
          expect(
            mockCreateOrderUseCase.capturedParams!.idempotencyKey.isNotEmpty,
            isTrue,
          );
        },
      );

      test('submits order with selected payment method when changed', () async {
        mockCreateOrderUseCase.resultToReturn = Right(tOrder);

        cubit.selectPaymentMethod(PaymentMethod.creditCard);

        await cubit.submitOrder(
          city: 'Alexandria',
          street: 'Corniche',
          building: '5A',
        );

        expect(mockCreateOrderUseCase.capturedParams, isNotNull);
        expect(
          mockCreateOrderUseCase.capturedParams!.paymentMethod,
          PaymentMethod.creditCard,
        );
        expect(
          mockCreateOrderUseCase.capturedParams!.address,
          const ShippingAddressEntity(
            city: 'Alexandria',
            street: 'Corniche',
            building: '5A',
          ),
        );
      });

      test(
        'emits [submitting, failure] when use case returns Left(Failure)',
        () async {
          const failureMessage = 'Failed to process order';
          mockCreateOrderUseCase.resultToReturn = const Left(
            ServerFailure(message: failureMessage),
          );

          final expectedStates = [
            const CheckoutState(status: CheckoutStatus.submitting),
            const CheckoutState(
              status: CheckoutStatus.failure,
              errorMessage: failureMessage,
            ),
          ];

          final expectation = expectLater(
            cubit.stream,
            emitsInOrder(expectedStates),
          );

          await cubit.submitOrder(
            city: 'Giza',
            street: 'Pyramids St',
            building: '100',
          );

          await expectation;
        },
      );
    });
  });
}
