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

  // MealLogs

  List<DateTime> getDayRange(DateTime date) {
    DateTime today = DateTime(date.year, date.month, date.day);
    DateTime tomorrow = DateTime(date.year, date.month, date.day + 1);

    return [today, tomorrow];
  }

  Future<void> updateMealLogData(String uid, DateTime date,
      {bool ateBreakfast = false,
      bool ateLunch = false,
      bool ateDinner = false,
      int numSnacks = 0}) async {
    MealLog currMealLog = await getMealLog(uid, date);

    return await mealLogCollection.doc(uid).set({
      'uid': uid,
      'date': date,
      'ateBreakfast': currMealLog.ateBreakfast != true
          ? ateBreakfast
          : currMealLog.ateBreakfast,
      'ateLunch':
          currMealLog.ateLunch != true ? ateLunch : currMealLog.ateLunch,
      'ateDinner':
          currMealLog.ateDinner != true ? ateDinner : currMealLog.ateDinner,
      'numSnacks': currMealLog.numSnacks + 1,
    });
  }

  MealLog _mealLogFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return MealLog.fromData(data ?? {});
  }

  Stream<MealLog> get mealLog {
    List<DateTime> dayRange = getDayRange(DateTime.now());

    return mealLogCollection
        .where('uid', isEqualTo: uid)
        .where('date', isLessThanOrEqualTo: dayRange[1])
        .where('date', isGreaterThanOrEqualTo: dayRange[0])
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return _mealLogFromSnapshot(snapshot.docs.first);
      } else {
        return MealLog(
          uid: uid,
          date: DateTime.now(),
        );
      }
    });
  }

  Future<MealLog> getMealLog(String uid, DateTime date) async {
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
      print(MealLog.fromData(data).ateLunch);
      return MealLog.fromData(data);
    } else {
      throw Exception('No meal log found');
    }
  }
}
