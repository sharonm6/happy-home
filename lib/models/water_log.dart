import 'package:cloud_firestore/cloud_firestore.dart';

class WaterLog {
  final String uid;
  final DateTime date;
  double cupsDrank;
  int numDaysOld;
  bool agedUp;

  WaterLog({
    required this.uid,
    required this.date,
    this.cupsDrank = 0.0,
    this.numDaysOld = 0,
    this.agedUp = false,
  });

  WaterLog.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        date = (data['date'] as Timestamp).toDate(),
        cupsDrank = data['cupsDrank'] ?? 0.0,
        numDaysOld = data['numDaysOld'] ?? 0,
        agedUp = data['agedUp'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'cupsDrank': cupsDrank,
      'numDaysOld': numDaysOld,
      'agedUp': agedUp,
    };
  }
}
