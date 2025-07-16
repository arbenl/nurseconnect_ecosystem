// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return _PaymentMethod.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethod {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get cardType =>
      throw _privateConstructorUsedError; // e.g., 'Visa', 'Mastercard'
  String get last4 => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String? get stripePaymentMethodId =>
      throw _privateConstructorUsedError; // ID from payment gateway (e.g., Stripe)
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodCopyWith<PaymentMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodCopyWith<$Res> {
  factory $PaymentMethodCopyWith(
    PaymentMethod value,
    $Res Function(PaymentMethod) then,
  ) = _$PaymentMethodCopyWithImpl<$Res, PaymentMethod>;
  @useResult
  $Res call({
    String id,
    String userId,
    String cardType,
    String last4,
    String brand,
    String? stripePaymentMethodId,
    bool isDefault,
  });
}

/// @nodoc
class _$PaymentMethodCopyWithImpl<$Res, $Val extends PaymentMethod>
    implements $PaymentMethodCopyWith<$Res> {
  _$PaymentMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cardType = null,
    Object? last4 = null,
    Object? brand = null,
    Object? stripePaymentMethodId = freezed,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            cardType:
                null == cardType
                    ? _value.cardType
                    : cardType // ignore: cast_nullable_to_non_nullable
                        as String,
            last4:
                null == last4
                    ? _value.last4
                    : last4 // ignore: cast_nullable_to_non_nullable
                        as String,
            brand:
                null == brand
                    ? _value.brand
                    : brand // ignore: cast_nullable_to_non_nullable
                        as String,
            stripePaymentMethodId:
                freezed == stripePaymentMethodId
                    ? _value.stripePaymentMethodId
                    : stripePaymentMethodId // ignore: cast_nullable_to_non_nullable
                        as String?,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentMethodImplCopyWith<$Res>
    implements $PaymentMethodCopyWith<$Res> {
  factory _$$PaymentMethodImplCopyWith(
    _$PaymentMethodImpl value,
    $Res Function(_$PaymentMethodImpl) then,
  ) = __$$PaymentMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String cardType,
    String last4,
    String brand,
    String? stripePaymentMethodId,
    bool isDefault,
  });
}

/// @nodoc
class __$$PaymentMethodImplCopyWithImpl<$Res>
    extends _$PaymentMethodCopyWithImpl<$Res, _$PaymentMethodImpl>
    implements _$$PaymentMethodImplCopyWith<$Res> {
  __$$PaymentMethodImplCopyWithImpl(
    _$PaymentMethodImpl _value,
    $Res Function(_$PaymentMethodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cardType = null,
    Object? last4 = null,
    Object? brand = null,
    Object? stripePaymentMethodId = freezed,
    Object? isDefault = null,
  }) {
    return _then(
      _$PaymentMethodImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        cardType:
            null == cardType
                ? _value.cardType
                : cardType // ignore: cast_nullable_to_non_nullable
                    as String,
        last4:
            null == last4
                ? _value.last4
                : last4 // ignore: cast_nullable_to_non_nullable
                    as String,
        brand:
            null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                    as String,
        stripePaymentMethodId:
            freezed == stripePaymentMethodId
                ? _value.stripePaymentMethodId
                : stripePaymentMethodId // ignore: cast_nullable_to_non_nullable
                    as String?,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodImpl implements _PaymentMethod {
  @override
  Map<String, dynamic> toMap() {
    return this.toJson();
  }  const _$PaymentMethodImpl({
    required this.id,
    required this.userId,
    required this.cardType,
    required this.last4,
    required this.brand,
    this.stripePaymentMethodId,
    this.isDefault = false,
  });

  factory _$PaymentMethodImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String cardType;
  // e.g., 'Visa', 'Mastercard'
  @override
  final String last4;
  @override
  final String brand;
  @override
  final String? stripePaymentMethodId;
  // ID from payment gateway (e.g., Stripe)
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'PaymentMethod(id: $id, userId: $userId, cardType: $cardType, last4: $last4, brand: $brand, stripePaymentMethodId: $stripePaymentMethodId, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.cardType, cardType) ||
                other.cardType == cardType) &&
            (identical(other.last4, last4) || other.last4 == last4) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.stripePaymentMethodId, stripePaymentMethodId) ||
                other.stripePaymentMethodId == stripePaymentMethodId) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    cardType,
    last4,
    brand,
    stripePaymentMethodId,
    isDefault,
  );

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      __$$PaymentMethodImplCopyWithImpl<_$PaymentMethodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodImplToJson(this);
  }
}

abstract class _PaymentMethod implements PaymentMethod {
  const factory _PaymentMethod({
    required final String id,
    required final String userId,
    required final String cardType,
    required final String last4,
    required final String brand,
    final String? stripePaymentMethodId,
    final bool isDefault,
  }) = _$PaymentMethodImpl;

  factory _PaymentMethod.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get cardType; // e.g., 'Visa', 'Mastercard'
  @override
  String get last4;
  @override
  String get brand;
  @override
  String? get stripePaymentMethodId; // ID from payment gateway (e.g., Stripe)
  @override
  bool get isDefault;

  /// Create a copy of PaymentMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodImplCopyWith<_$PaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
