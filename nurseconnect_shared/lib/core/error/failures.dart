
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List _properties;

  const Failure([this.message = 'An unexpected error occurred', this._properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [message, ..._properties];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server Error'}) : super(message);

  @override
  List<Object?> get props => [message];
}
