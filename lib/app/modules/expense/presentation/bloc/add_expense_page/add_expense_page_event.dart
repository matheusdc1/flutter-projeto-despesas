part of 'add_expense_page_bloc.dart';

sealed class AddExpensePageEvent extends Equatable {
  const AddExpensePageEvent();
}

class AddExpensePageSubmitButtonClicked extends AddExpensePageEvent {
  final String title;
  final double value;
  final CategoryType category;
  final DateTime date;
  final String userId;

  const AddExpensePageSubmitButtonClicked({
    required this.title,
    required this.value,
    required this.category,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, value, category, date, userId];
}
