import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_despesas/app/core/helpers/timestamp_converter.dart';
import 'package:equatable/equatable.dart';

class CreateExpenseReq extends Equatable {
  final String title;
  final double value;
  final String category;
  final DateTime date;
  final String userId;

  const CreateExpenseReq({
    required this.title,
    required this.value,
    required this.category,
    required this.date,
    required this.userId,
  });

  factory CreateExpenseReq.fromJson(Map<String, dynamic> map) {
    return CreateExpenseReq(
        title: map['title'] ?? '',
        value: map['value'] ?? '',
        category: map['category'] ?? '',
        date: (map['date'] as Timestamp).toDate(),
        userId: map['userId'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'category': category,
      'date': TimestampConverter.toTimestamp(date),
      'createdAt': TimestampConverter.toTimestamp(DateTime.now()),
      'userId': userId,
    };
  }

  @override
  List<Object?> get props => [title, value, category, date, userId];
}
