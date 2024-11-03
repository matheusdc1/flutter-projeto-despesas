import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class ExpenseRepository {
  Future<Result<Expense, DomainFailure>> createExpense({
    required String title,
    required double value,
    required String category,
    required DateTime date,
    required String userId,
  });

  Future<Result<List<Expense>, DomainFailure>> getExpenses({
    required String userId,
  });

  Future<Result<Expense, DomainFailure>> getExpense({
    required String id,
    required String userId,
  });

  Future<Result<List<Expense>, DomainFailure>> deleteExpense({
    required String id,
    required String userId,
  });

  Future<Result<List<Expense>, DomainFailure>> getExpensesFilteredSorted({
    CategoryType? category,
    required String sortBy,
    required String userId,
  });

  Future<Result<Expense, DomainFailure>> editExpense({
    required String id,
    required String userId,
    String? title,
    double? value,
    String? category,
    DateTime? date,
  });
}
