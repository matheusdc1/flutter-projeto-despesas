import 'package:equatable/equatable.dart';

class DomainFailure extends Equatable implements Exception {
  final String message;

  const DomainFailure(this.message);

  @override
  toString() => message;

  @override
  List<Object?> get props => [message];
}
