part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();
}

final class ExpenseInitial extends ExpenseState {
  @override
  List<Object> get props => [];
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();

  @override
  List<Object?> get props => [];
}

class ExpenseSuccess extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseSuccess(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}
