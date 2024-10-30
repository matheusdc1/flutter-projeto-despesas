import 'package:equatable/equatable.dart';

class RegisterReq extends Equatable {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterReq({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}
