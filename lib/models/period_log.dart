import 'package:cloud_firestore/cloud_firestore.dart';

class PeriodLog {
  final String uid;
  final DateTime date;
  bool currently;
  int duration; // in days

  PeriodLog({
    required this.uid,
    required this.date,
    this.currently = false,
    this.duration = 0,
  });

  PeriodLog.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        date = (data['date'] as Timestamp).toDate(),
        currently = data['currently'] ?? false,
        duration = data['duration'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'currently': currently,
      'duration': duration,
    };
  }
}
