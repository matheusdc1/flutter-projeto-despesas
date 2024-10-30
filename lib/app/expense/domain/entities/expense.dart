import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final double value;
  final CategoryType category;
  final DateTime date;
  final String userId;

  const Expense({
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
