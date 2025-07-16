// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodImpl _$$PaymentMethodImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cardType: json['cardType'] as String,
      last4: json['last4'] as String,
      brand: json['brand'] as String,
      stripePaymentMethodId: json['stripePaymentMethodId'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaymentMethodImplToJson(_$PaymentMethodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'cardType': instance.cardType,
      'last4': instance.last4,
      'brand': instance.brand,
      'stripePaymentMethodId': instance.stripePaymentMethodId,
      'isDefault': instance.isDefault,
    };
