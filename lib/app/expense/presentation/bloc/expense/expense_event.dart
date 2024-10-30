part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

class ExpenseEnteredHomePage extends ExpenseEvent {
  final String userId;

  const ExpenseEnteredHomePage({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ExpenseCreateExpenseButtonClicked extends ExpenseEvent {
  final String title;
  final double value;
  final CategoryType category;
  final DateTime date;
  final String userId;

  const ExpenseCreateExpenseButtonClicked({
    required this.title,
    required this.value,
    required this.category,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, value, category, date, userId];
}

class ExpenseEditExpenseButtonClicked extends ExpenseEvent {
  final String id;
  final String title;
  final double value;
  final CategoryType category;
  final DateTime date;
  final String userId;

  const ExpenseEditExpenseButtonClicked({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.date,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, title, value, category, date, userId];
}

class ExpenseDeleteExpenseButtonClicked extends ExpenseEvent {
  final String id;
  final String userId;

  const ExpenseDeleteExpenseButtonClicked({
    required this.id,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, userId];
}

class ExpenseReloadRequested extends ExpenseEvent {
  final String userId;

  const ExpenseReloadRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ExpenseEnteredListPage extends ExpenseEvent {
  final String userId;

  const ExpenseEnteredListPage({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ExpenseFilterChanged extends ExpenseEvent {
  final CategoryType? category;
  final String sortBy;
  final String userId;

  const ExpenseFilterChanged({
    this.category,
    required this.sortBy,
    required this.userId,
  });

  @override
  List<Object?> get props => [category, sortBy, userId];
}
