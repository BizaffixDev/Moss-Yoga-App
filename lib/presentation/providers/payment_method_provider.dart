import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moss_yoga/data/models/payment_method.dart';

final paymentMethodProvider = Provider<List<PaymentMethod>>((ref) {
  return paymentMethodsList;
});