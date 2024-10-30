import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/modules/auth/domain/entities/user.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AuthRepository {
  Future<Result<Unit, DomainFailure>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<Result<Unit, DomainFailure>> login({
    required String email,
    required String password,
  });

  Future<Result<Unit, DomainFailure>> logout();

  Future<Result<bool, DomainFailure>> getIsAuthenticated();

  Future<Result<User, DomainFailure>> getUser();
}
