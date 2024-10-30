import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/expense/domain/repositories/expense_repository.dart';
import 'package:result_dart/result_dart.dart';

class CreateExpense
    implements UseCase<Expense, DomainFailure, CreateExpenseParams> {
  final ExpenseRepository _repository;

  CreateExpense(this._repository);

  @override
  Future<Result<Expense, DomainFailure>> execute(
      CreateExpenseParams params) async {
    return await _repository.createExpense(
      title: params.title,
      value: params.value,
      category: params.category,
      date: params.date,
      userId: params.userId,
    );
  }
}

class CreateExpenseParams {
  final String title;
  final double value;
  final String category;
  final DateTime date;
  final String userId;

  CreateExpenseParams({
    required this.title,
    required this.value,
    required this.category,
    required this.date,
    required this.userId,
  });
}
