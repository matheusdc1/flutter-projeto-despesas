part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLoginButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterButtonPressed extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const AuthRegisterButtonPressed({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class AuthLogoutButtonPressed extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AppInitializing extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AppStartGetUser extends AuthEvent {
  @override
  List<Object?> get props => [];
}
