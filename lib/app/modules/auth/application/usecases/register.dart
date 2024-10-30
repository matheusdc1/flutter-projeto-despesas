import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class Register implements UseCase<Unit, DomainFailure, RegisterParams> {
  final AuthRepository _authRepository;

  Register(this._authRepository);

  @override
  Future<Result<Unit, DomainFailure>> execute(RegisterParams params) async {
    return await _authRepository.register(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
    );
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}
