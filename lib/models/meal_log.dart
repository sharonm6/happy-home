import 'package:cloud_firestore/cloud_firestore.dart';

class MealLog {
  final String uid;
  final DateTime date;
  bool ateBreakfast;
  bool ateLunch;
  bool ateDinner;
  int numSnacks;

  MealLog({
    required this.uid,
    required this.date,
    this.ateBreakfast = false,
    this.ateLunch = false,
    this.ateDinner = false,
    this.numSnacks = 0,
  });

  MealLog.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        date = (data['date'] as Timestamp).toDate(),
        ateBreakfast = data['ateBreakfast'] ?? false,
        ateLunch = data['ateLunch'] ?? false,
        ateDinner = data['ateDinner'] ?? false,
        numSnacks = data['numSnacks'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'ateBreakfast': ateBreakfast,
      'ateLunch': ateLunch,
      'ateDinner': ateDinner,
      'numSnacks': numSnacks,
    };
  }
}
