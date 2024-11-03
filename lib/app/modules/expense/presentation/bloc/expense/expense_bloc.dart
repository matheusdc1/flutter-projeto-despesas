import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/create_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/delete_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/edit_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/filter_sort_expenses.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/get_expenses.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_event.dart';

part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final CreateExpense _createExpense;
  final GetExpenses _getExpenses;
  final DeleteExpense _deleteExpense;
  final EditExpense _editExpense;
  final FilterSortExpenses _filterSortExpenses;

  ExpenseBloc({
    required GetExpenses getExpenses,
    required CreateExpense createExpense,
    required DeleteExpense deleteExpense,
    required EditExpense editExpense,
    required FilterSortExpenses filterSortExpenses,
  })  : _createExpense = createExpense,
        _deleteExpense = deleteExpense,
        _getExpenses = getExpenses,
        _editExpense = editExpense,
        _filterSortExpenses = filterSortExpenses,
        super(ExpenseInitial()) {
    on<ExpenseEnteredHomePage>(_onExpenseEnteredHomePage);
    on<ExpenseCreateExpenseButtonClicked>(_onExpenseCreateExpenseButtonClicked);
    on<ExpenseDeleteExpenseButtonClicked>(_onExpenseDeleteExpenseButtonClicked);
    on<ExpenseEditExpenseButtonClicked>(_onExpenseEditExpenseButtonClicked);
    on<ExpenseReloadRequested>(_onExpenseReloadRequested);
    on<ExpenseEnteredListPage>(_onExpenseEnteredListPage);
    on<ExpenseFilterChanged>(_onExpenseFilterChanged);
  }

  Future<void> _onExpenseEnteredHomePage(
    ExpenseEnteredHomePage event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final output = await _getExpenses.execute(event.userId);
    output.fold(
      (expenses) => emit(ExpenseSuccess(expenses)),
      (failure) => emit(ExpenseError(failure.message)),
    );
  }

  Future<void> _onExpenseCreateExpenseButtonClicked(
    ExpenseCreateExpenseButtonClicked event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final output = await _createExpense.execute(
      CreateExpenseParams(
        title: event.title,
        value: event.value,
        category: event.category.name,
        date: event.date,
        userId: event.userId,
      ),
    );
    output.fold(
      (expense) => emit(
        ExpenseSuccess([expense]),
      ),
      (failure) => emit(
        ExpenseError(failure.message),
      ),
    );
  }

  Future<void> _onExpenseDeleteExpenseButtonClicked(
    ExpenseDeleteExpenseButtonClicked event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final output = await _deleteExpense
        .execute(DeleteExpenseParams(id: event.id, userId: event.userId));
    output.fold(
      (expense) => emit(ExpenseSuccess(expense)),
      (failure) => emit(ExpenseError(failure.message)),
    );
  }

  Future<void> _onExpenseEditExpenseButtonClicked(
    ExpenseEditExpenseButtonClicked event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final output = await _editExpense.execute(
      EditExpenseParams(
        id: event.id,
        userId: event.userId,
        title: event.title,
        value: event.value,
        category: event.category.name,
        date: event.date,
      ),
    );
    output.fold(
      (expense) {
        emit(ExpenseSuccess([expense]));
      },
      (failure) => emit(
        ExpenseError(failure.message),
      ),
    );
  }

  Future<void> _onExpenseReloadRequested(
    ExpenseReloadRequested event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final output = await _getExpenses.execute(event.userId);
    output.fold(
      (expenses) => emit(ExpenseSuccess(expenses)),
      (failure) => emit(ExpenseError(failure.message)),
    );
  }

  Future<void> _onExpenseEnteredListPage(
    ExpenseEnteredListPage event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final output = await _getExpenses.execute(event.userId);
    output.fold(
      (expenses) => emit(ExpenseSuccess(expenses)),
      (failure) => emit(ExpenseError(failure.message)),
    );
  }

  Future<void> _onExpenseFilterChanged(
    ExpenseFilterChanged event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());
    final params = FilterSortParams(
      category: event.category,
      sortBy: event.sortBy,
      userId: event.userId,
    );
    final output = await _filterSortExpenses.execute(params);
    output.fold(
      (expenses) => emit(ExpenseSuccess(expenses)),
      (failure) => emit(ExpenseError(failure.message)),
    );
  }
}
