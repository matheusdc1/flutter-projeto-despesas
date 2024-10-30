import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/expense/domain/repositories/expense_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:result_dart/result_dart.dart';

class GetExpense implements UseCase<Expense, DomainFailure, GetExpenseParams> {
  final ExpenseRepository _repository;

  GetExpense(this._repository);

  @override
  Future<Result<Expense, DomainFailure>> execute(
      GetExpenseParams params) async {
    return await _repository.getExpense(id: params.id, userId: params.userId);
  }
}

class GetExpenseParams extends Equatable {
  final String id;
  final String userId;

  const GetExpenseParams({required this.id, required this.userId});

  @override
  List<Object?> get props => [id, userId];
}
