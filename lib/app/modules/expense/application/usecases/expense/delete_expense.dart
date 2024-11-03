import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/modules/expense/domain/repositories/expense_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:result_dart/result_dart.dart';

class DeleteExpense
    implements UseCase<List<Expense>, DomainFailure, DeleteExpenseParams> {
  final ExpenseRepository _repository;

  DeleteExpense(this._repository);

  @override
  Future<Result<List<Expense>, DomainFailure>> execute(
      DeleteExpenseParams params) async {
    return await _repository.deleteExpense(
        id: params.id, userId: params.userId);
  }
}

class DeleteExpenseParams extends Equatable {
  final String id;
  final String userId;

  const DeleteExpenseParams({required this.id, required this.userId});

  @override
  List<Object?> get props => [id, userId];
}
