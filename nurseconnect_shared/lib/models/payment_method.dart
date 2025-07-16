import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String userId,
    required String cardType, // e.g., 'Visa', 'Mastercard'
    required String last4,
    required String brand,
    String? stripePaymentMethodId, // ID from payment gateway (e.g., Stripe)
    @Default(false) bool isDefault,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  factory PaymentMethod.fromMap(String id, Map<String, dynamic> map) {
    return PaymentMethod.fromJson(map).copyWith(id: id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cardType': cardType,
      'last4': last4,
      'brand': brand,
      'stripePaymentMethodId': stripePaymentMethodId,
      'isDefault': isDefault,
    };
  }
}