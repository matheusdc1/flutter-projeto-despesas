import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/core/errors/failures.dart';
import 'package:controle_despesas/app/modules/expense/application/dtos/create_expense_dto.dart';
import 'package:controle_despesas/app/modules/expense/application/dtos/update_expense_dto.dart';
import 'package:controle_despesas/app/modules/expense/data/datasources/expense_remote_datasource.dart';
import 'package:controle_despesas/app/modules/expense/data/models/expense_model.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/modules/expense/domain/repositories/expense_repository.dart';
import 'package:result_dart/result_dart.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDatasource _remoteDatasource;

  ExpenseRepositoryImpl(this._remoteDatasource);

  @override
  Future<Result<List<Expense>, DomainFailure>> getExpenses(
      {required String userId}) async {
    try {
      final response = await _remoteDatasource.getExpenses(userId: userId);
      final expenses =
          response.map((expense) => ExpenseModel.toEntity(expense)).toList();
      return Success(expenses);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<Expense, DomainFailure>> getExpense({
    required String id,
    required String userId,
  }) async {
    try {
      final response =
          await _remoteDatasource.getExpense(id: id, userId: userId);
      return Success(ExpenseModel.toEntity(response));
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Expense>, DomainFailure>> deleteExpense({
    required String id,
    required String userId,
  }) async {
    try {
      final response =
          await _remoteDatasource.deleteExpense(id: id, userId: userId);
      final expenses =
          response.map((expense) => ExpenseModel.toEntity(expense)).toList();
      return Success(expenses);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<Expense, DomainFailure>> createExpense({
    required String title,
    required double value,
    required String category,
    required DateTime date,
    required String userId,
  }) async {
    try {
      final response = await _remoteDatasource.createExpense(
        req: CreateExpenseReq(
          title: title,
          value: value,
          category: category,
          date: date,
          userId: userId,
        ),
      );
      return Success(ExpenseModel.toEntity(response));
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Expense>, DomainFailure>> getExpensesFilteredSorted({
    CategoryType? category,
    required String sortBy,
    required String userId,
  }) async {
    try {
      final response = await _remoteDatasource.getExpensesFilteredSorted(
        category: category?.name,
        sortBy: sortBy,
        userId: userId,
      );
      final expenses =
          response.map((expense) => ExpenseModel.toEntity(expense)).toList();
      return Success(expenses);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }

  @override
  Future<Result<Expense, DomainFailure>> editExpense({
    required String id,
    required String userId,
    String? title,
    double? value,
    String? category,
    DateTime? date,
  }) async {
    try {
      final updateReq = UpdateExpenseReq(
        id: id,
        userId: userId,
        title: title,
        value: value,
        category: category,
        date: date,
      );

      final response = await _remoteDatasource.editExpense(req: updateReq);
      final updatedExpense = ExpenseModel.toEntity(response);
      return Success(updatedExpense);
    } catch (e) {
      return Failure(DomainFailure(e.toString()));
    }
  }
}
