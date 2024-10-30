part of 'add_expense_page_bloc.dart';

sealed class AddExpensePageState extends Equatable {
  const AddExpensePageState();
}

final class AddExpensePageInitial extends AddExpensePageState {
  @override
  List<Object> get props => [];
}

class AddExpensePageLoading extends AddExpensePageState {
  const AddExpensePageLoading();

  @override
  List<Object?> get props => [];
}

class AddExpensePageSuccess extends AddExpensePageState {
  const AddExpensePageSuccess();

  @override
  List<Object?> get props => [];
}

class AddExpensePageError extends AddExpensePageState {
  final String message;

  const AddExpensePageError(this.message);

  @override
  List<Object?> get props => [];
}
