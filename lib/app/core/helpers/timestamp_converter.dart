import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  static Timestamp toTimestamp(DateTime date) {
    return Timestamp.fromDate(date);
  }

  static DateTime toDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp? toTimestampNullable(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }

  static DateTime? toDateTimeNullable(Timestamp? timestamp) {
    return timestamp?.toDate();
  }
}
