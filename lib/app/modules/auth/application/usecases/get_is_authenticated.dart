import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class GetIsAuthenticated implements UseCase<bool, DomainFailure, NoParams> {
  final AuthRepository _repository;

  GetIsAuthenticated(this._repository);

  @override
  Future<Result<bool, DomainFailure>> execute([NoParams? _]) async {
    return await _repository.getIsAuthenticated();
  }
}
