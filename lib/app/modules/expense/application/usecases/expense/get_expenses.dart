import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/modules/expense/domain/repositories/expense_repository.dart';
import 'package:result_dart/result_dart.dart';

class GetExpenses implements UseCase<List<Expense>, DomainFailure, String> {
  final ExpenseRepository _repository;

  GetExpenses(this._repository);

  @override
  Future<Result<List<Expense>, DomainFailure>> execute(String userId) async {
    return await _repository.getExpenses(userId: userId);
  }
}
