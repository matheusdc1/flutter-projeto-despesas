import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/core/helpers/timestamp_converter.dart';
import 'package:controle_despesas/app/expense/domain/entities/expense.dart';
import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  final String id;
  final String title;
  final double value;
  final CategoryType category;
  final DateTime date;
  final String userId;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.value,
    required this.category,
    required this.date,
    required this.userId,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      value: (map['value'] is int)
          ? (map['value'] as int).toDouble()
          : (map['value'] ?? 0.0) as double,
      category: _getCategoryFromString(map['category'] ?? ''),
      date: TimestampConverter.toDateTime(map['date']),
      userId: map['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'category': category.name,
      'date': TimestampConverter.toTimestamp(date),
      'userId': userId,
    };
  }

  static Expense toEntity(ExpenseModel model) {
    return Expense(
      id: model.id,
      title: model.title,
      value: model.value,
      category: model.category,
      date: model.date,
      userId: model.userId,
    );
  }

  static CategoryType _getCategoryFromString(String category) {
    try {
      return CategoryType.values.byName(category);
    } catch (e) {
      return CategoryType.other;
    }
  }

  @override
  List<Object?> get props => [id, title, value, category, date, userId];
}
