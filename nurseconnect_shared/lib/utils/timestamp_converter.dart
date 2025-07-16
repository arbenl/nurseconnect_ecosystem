import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  Timestamp fromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp;
    } else if (timestamp is Map<String, dynamic>) {
      // Handle cases where timestamp might be stored as a map (e.g., from JSON serialization of Timestamp)
      return Timestamp(timestamp['seconds'] as int, timestamp['nanoseconds'] as int);
    } else if (timestamp is int) {
      // Handle cases where timestamp might be stored as milliseconds since epoch
      return Timestamp.fromMillisecondsSinceEpoch(timestamp);
    }
    throw ArgumentError('Invalid timestamp format');
  }

  @override
  dynamic toJson(Timestamp timestamp) => timestamp;
}
