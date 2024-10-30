import 'package:controle_despesas/app/modules/auth/application/usecases/get_is_authenticated.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/get_user.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/login.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/logout.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/register.dart';
import 'package:controle_despesas/app/modules/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Register _register;
  final Login _login;
  final Logout _logout;
  final GetIsAuthenticated _getIsAuthenticated;
  final GetUser _getUser;

  AuthBloc({
    required Register register,
    required Login login,
    required Logout logout,
    required GetIsAuthenticated getIsAuthenticated,
    required GetUser getUser,
  })  : _register = register,
        _login = login,
        _logout = logout,
        _getIsAuthenticated = getIsAuthenticated,
        _getUser = getUser,
        super(AuthInitial()) {
    on<AuthRegisterButtonPressed>(_onAuthRegisterButtonPressed);
    on<AuthLoginButtonPressed>(_onAuthLoginButtonPressed);
    on<AuthLogoutButtonPressed>(_onAuthLogoutButtonPressed);
    on<AppInitializing>(_onAppInitializing);
    on<AppStartGetUser>(_onAppStartGetUser);
  }

  Future<void> _onAuthRegisterButtonPressed(
    AuthRegisterButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final output = await _register.execute(
      RegisterParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      ),
    );
    output.fold(
      (success) => emit(AuthSuccess()),
      (failure) => emit(AuthFailure(failure.message)),
    );
  }

  Future<void> _onAuthLoginButtonPressed(
    AuthLoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final loginResult = await _login.execute(
      LoginParams(email: event.email, password: event.password),
    );

    await loginResult.fold(
      (success) async {
        final userResult = await _getUser.execute();
        await userResult.fold(
          (user) async => emit(Authenticated(user)),
          (failure) async => emit(AuthFailure(failure.message)),
        );
      },
      (failure) async => emit(AuthFailure(failure.message)),
    );
  }

  Future<void> _onAuthLogoutButtonPressed(
    AuthLogoutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final output = await _logout.execute();
    await output.fold(
      (success) async => emit(Unauthenticated()),
      (failure) async => emit(AuthFailure(failure.message)),
    );
  }

  Future<void> _onAppInitializing(
    AppInitializing event,
    Emitter<AuthState> emit,
  ) async {
    final authResult = await _getIsAuthenticated.execute();
    await authResult.fold(
      (isAuthenticated) async {
        if (!isAuthenticated) {
          emit(Unauthenticated());
          return;
        }
        final userResult = await _getUser.execute();
        await userResult.fold(
          (user) async => emit(Authenticated(user)),
          (failure) async => emit(AuthFailure(failure.message)),
        );
      },
      (failure) async => emit(AuthFailure(failure.message)),
    );
  }

  Future<void> _onAppStartGetUser(
    AppStartGetUser event,
    Emitter<AuthState> emit,
  ) async {
    final userResult = await _getUser.execute();
    await userResult.fold(
      (user) async => emit(Authenticated(user)),
      (failure) async => emit(AuthFailure(failure.message)),
    );
  }
}
