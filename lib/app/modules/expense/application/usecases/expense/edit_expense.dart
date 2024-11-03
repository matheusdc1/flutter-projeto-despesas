import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/modules/expense/domain/repositories/expense_repository.dart';
import 'package:result_dart/result_dart.dart';

class EditExpense
    implements UseCase<Expense, DomainFailure, EditExpenseParams> {
  final ExpenseRepository _repository;

  EditExpense(this._repository);

  @override
  Future<Result<Expense, DomainFailure>> execute(
    EditExpenseParams params,
  ) async {
    return await _repository.editExpense(
      id: params.id,
      userId: params.userId,
      title: params.title,
      value: params.value,
      category: params.category,
      date: params.date,
    );
  }
}

class EditExpenseParams {
  final String id;
  final String userId;
  final String? title;
  final double? value;
  final String? category;
  final DateTime? date;

  EditExpenseParams({
    required this.id,
    required this.userId,
    this.title,
    this.value,
    this.category,
    this.date,
  });
}
