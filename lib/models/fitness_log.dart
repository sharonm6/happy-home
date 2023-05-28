import 'package:cloud_firestore/cloud_firestore.dart';

class FitnessLog {
  final String uid;
  final DateTime date;
  double gymTime; // in hours
  double walkTime; // in hours
  double yogaTime; // in hours

  FitnessLog({
    required this.uid,
    required this.date,
    this.gymTime = 0.0,
    this.walkTime = 00,
    this.yogaTime = 0.0,
  });

  FitnessLog.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        date = (data['date'] as Timestamp).toDate(),
        gymTime = data['gymTime'] ?? 0.0,
        walkTime = data['walkTime'] ?? 0.0,
        yogaTime = data['yogaTime'] ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'gymTime': gymTime,
      'walkTime': walkTime,
      'yogaTime': yogaTime,
    };
  }
}
