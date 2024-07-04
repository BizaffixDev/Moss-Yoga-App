class PaymentIntentModelRequest {
  final String amount;
  final String currency;
  final String description;

  PaymentIntentModelRequest({
    required this.amount,
    required this.currency,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'description': description,
    };
  }
}
