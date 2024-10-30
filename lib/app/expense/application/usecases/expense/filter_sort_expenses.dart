import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/core/interfaces/usecase.dart';
import 'package:controle_despesas/app/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/expense/domain/repositories/expense_repository.dart';
import 'package:result_dart/result_dart.dart';

class FilterSortExpenses
    implements UseCase<List<Expense>, DomainFailure, FilterSortParams> {
  final ExpenseRepository _repository;

  FilterSortExpenses(this._repository);

  @override
  Future<Result<List<Expense>, DomainFailure>> execute(
      FilterSortParams params) async {
    return await _repository.getExpensesFilteredSorted(
      category: params.category,
      sortBy: params.sortBy,
      userId: params.userId,
    );
  }
}

class FilterSortParams {
  final CategoryType? category;
  final String sortBy;
  final String userId;

  FilterSortParams({this.category, required this.sortBy, required this.userId});
}
