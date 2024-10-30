import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/modules/auth/application/dtos/login_dto.dart';
import 'package:controle_despesas/app/modules/auth/application/dtos/register_dto.dart';
import 'package:controle_despesas/app/modules/auth/data/datasources/auth_remote_datasource.dart';
import 'package:controle_despesas/app/modules/auth/data/models/user_model.dart';
import 'package:controle_despesas/app/modules/auth/domain/entities/user.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRepositoryImpl(this._authRemoteDatasource);

  @override
  Future<Result<Unit, DomainFailure>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _authRemoteDatasource.register(
        req: RegisterReq(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        ),
      );
      return const Success(unit);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit, DomainFailure>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _authRemoteDatasource.login(
          req: LoginReq(email: email, password: password));
      return const Success(unit);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<Unit, DomainFailure>> logout() async {
    try {
      await _authRemoteDatasource.logout();
      return const Success(unit);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool, DomainFailure>> getIsAuthenticated() async {
    try {
      final isAuthenticated = await _authRemoteDatasource.getIsAuthenticated();
      if (!isAuthenticated) return const Success(false);
      return const Success(true);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<User, DomainFailure>> getUser() async {
    try {
      final user = await _authRemoteDatasource.getUser();
      return Success(UserModel.toEntity(user));
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }
}
