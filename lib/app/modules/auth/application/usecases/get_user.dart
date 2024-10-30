import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/auth/domain/entities/user.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class GetUser implements UseCase<User, DomainFailure, NoParams> {
  final AuthRepository _repository;

  GetUser(this._repository);

  @override
  Future<Result<User, DomainFailure>> execute([NoParams? _]) async {
    return await _repository.getUser();
  }
}
