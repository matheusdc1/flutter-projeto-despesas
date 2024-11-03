import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_despesas/app/core/helpers/timestamp_converter.dart';
import 'package:equatable/equatable.dart';

class UpdateExpenseReq extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final double? value;
  final String? category;
  final DateTime? date;

  const UpdateExpenseReq({
    required this.id,
    required this.userId,
    this.title,
    this.value,
    this.category,
    this.date,
  });

  factory UpdateExpenseReq.fromJson(Map<String, dynamic> map) {
    return UpdateExpenseReq(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'],
      value: (map['value'] is num) ? (map['value'] as num).toDouble() : null,
      category: map['category'],
      date: map['date'] != null ? (map['date'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'updatedAt': TimestampConverter.toTimestamp(DateTime.now()),
    };
    if (title != null) data['title'] = title;
    if (value != null) data['value'] = value;
    if (category != null) data['category'] = category;
    if (date != null) data['date'] = TimestampConverter.toTimestamp(date!);
    return data;
  }

  @override
  List<Object?> get props => [id, userId, title, value, category, date];
}
