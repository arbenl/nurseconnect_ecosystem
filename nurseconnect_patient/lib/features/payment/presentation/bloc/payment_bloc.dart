import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import 'package:nurseconnect_patient/features/payment/domain/repositories/payment_repository.dart';


class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<AddPaymentMethod>(_onAddPaymentMethod);
    on<DeletePaymentMethod>(_onDeletePaymentMethod);
    on<SetDefaultPaymentMethod>(_onSetDefaultPaymentMethod);
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.getPaymentMethods(event.userId);
    result.fold(
      (failure) => emit(PaymentError(message: 'Failed to load payment methods.')),
      (paymentMethods) => emit(PaymentMethodsLoaded(paymentMethods: paymentMethods)),
    );
  }

  Future<void> _onAddPaymentMethod(
    AddPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.addPaymentMethod(event.userId, event.paymentDetails);
    result.fold(
      (failure) => emit(PaymentError(message: 'Failed to add payment method.')),
      (paymentMethod) => emit(PaymentOperationSuccess(message: 'Payment method added successfully!'))
    );
    add(LoadPaymentMethods(userId: event.userId));
  }

  Future<void> _onDeletePaymentMethod(
    DeletePaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.deletePaymentMethod(event.paymentMethodId);
    result.fold(
      (failure) => emit(PaymentError(message: 'Failed to delete payment method.')),
      (_) => emit(PaymentOperationSuccess(message: 'Payment method deleted successfully!'))
    );
  }

  Future<void> _onSetDefaultPaymentMethod(
    SetDefaultPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    final result = await paymentRepository.setDefaultPaymentMethod(event.userId, event.paymentMethodId);
    result.fold(
      (failure) => emit(PaymentError(message: 'Failed to set default payment method.')),
      (_) => emit(PaymentOperationSuccess(message: 'Default payment method set successfully!'))
    );
    add(LoadPaymentMethods(userId: event.userId));
  }
}

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class LoadPaymentMethods extends PaymentEvent {
  final String userId;

  const LoadPaymentMethods({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AddPaymentMethod extends PaymentEvent {
  final String userId;
  final Map<String, dynamic> paymentDetails;

  const AddPaymentMethod({required this.userId, required this.paymentDetails});

  @override
  List<Object> get props => [userId, paymentDetails];
}

class DeletePaymentMethod extends PaymentEvent {
  final String paymentMethodId;

  const DeletePaymentMethod({required this.paymentMethodId});

  @override
  List<Object> get props => [paymentMethodId];
}

class SetDefaultPaymentMethod extends PaymentEvent {
  final String userId;
  final String paymentMethodId;

  const SetDefaultPaymentMethod({required this.userId, required this.paymentMethodId});

  @override
  List<Object> get props => [userId, paymentMethodId];
}

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethod> paymentMethods;

  const PaymentMethodsLoaded({required this.paymentMethods});

  @override
  List<Object> get props => [paymentMethods];
}

class PaymentOperationSuccess extends PaymentState {
  final String message;

  const PaymentOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object> get props => [message];
}