import 'package:happy_home/models/user.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  // collection references

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference mealLogCollection =
      FirebaseFirestore.instance.collection('meal_logs');

  // Users

  Future<void> updateUserData(
    String name,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  User _userFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return User(uid: uid, name: data?['name'], email: data?['email']);
  }

  Stream<User> get user {
    return userCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => _userFromSnapshot(snapshot));
  }

  // Helper Functions

  List<DateTime> getDayRange(DateTime date) {
    DateTime today = DateTime(date.year, date.month, date.day);
    DateTime tomorrow = DateTime(date.year, date.month, date.day + 1);

    return [today, tomorrow];
  }

  // MealLogs

  Future<void> updateMealLogData(String uid, DateTime date,
      {bool ateBreakfast = false,
      bool ateLunch = false,
      bool ateDinner = false,
      bool addSnack = false}) async {
    List<dynamic> mealLogInfo = await getMealLog(uid, date);
    MealLog currMealLog = mealLogInfo[0];
    String docId = mealLogInfo[1];

    return await mealLogCollection.doc(docId).set({
      'uid': uid,
      'date': currMealLog.date,
      'ateBreakfast': currMealLog.ateBreakfast != true
          ? ateBreakfast
          : currMealLog.ateBreakfast,
      'ateLunch':
          currMealLog.ateLunch != true ? ateLunch : currMealLog.ateLunch,
      'ateDinner':
          currMealLog.ateDinner != true ? ateDinner : currMealLog.ateDinner,
      'numSnacks': addSnack ? currMealLog.numSnacks + 1 : currMealLog.numSnacks,
    });
  }

  MealLog _mealLogFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return MealLog.fromData(data ?? {});
  }

  Stream<List<MealLog>> get mealLog {
    return mealLogCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          return _mealLogFromSnapshot(doc);
        }).toList();
      } else {
        return [
          MealLog(
            uid: uid,
            date: DateTime.now(),
          )
        ];
      }
    });
  }

  Future<List<dynamic>> getMealLog(String uid, DateTime date) async {
    List<DateTime> dayRange = getDayRange(date);

    QuerySnapshot querySnapshot = await mealLogCollection
        .where('uid', isEqualTo: uid)
        .where('date', isLessThanOrEqualTo: dayRange[1])
        .where('date', isGreaterThanOrEqualTo: dayRange[0])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return [MealLog.fromData(data), documentSnapshot.id];
    } else {
      throw Exception('No meal log found');
    }
  }

  // WaterLogs
}
