import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class Logout implements UseCase<Unit, DomainFailure, NoParams> {
  final AuthRepository _authRepository;

  Logout(this._authRepository);

  @override
  Future<Result<Unit, DomainFailure>> execute([NoParams? _]) async {
    return await _authRepository.logout();
  }
}
