enum PaymentMethod {
  cash('CASH'),
  creditCard('CREDIT_CARD');

  final String value;
  const PaymentMethod(this.value);

  static PaymentMethod fromString(String value) {
    final normalized = value
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .toUpperCase();
    if (normalized == 'CREDITCARD' || normalized == 'CREDIT_CARD') {
      return PaymentMethod.creditCard;
    }
    return PaymentMethod.values.firstWhere(
      (e) => e.value == normalized,
      orElse: () => PaymentMethod.cash,
    );
  }
}
