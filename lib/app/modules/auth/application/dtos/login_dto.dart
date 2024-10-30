import 'package:equatable/equatable.dart';

class LoginReq extends Equatable {
  final String email;
  final String password;

  const LoginReq({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
