import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class Login implements UseCase<Unit, DomainFailure, LoginParams> {
  final AuthRepository _authRepository;

  Login(this._authRepository);

  @override
  Future<Result<Unit, DomainFailure>> execute(LoginParams params) async {
    return await _authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
