import 'package:happy_home/models/period_log.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_home/models/water_log.dart';
import 'package:happy_home/models/fitness_log.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ''});

  // collection references

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference mealLogCollection =
      FirebaseFirestore.instance.collection('meal_logs');

  final CollectionReference waterLogCollection =
      FirebaseFirestore.instance.collection('water_logs');

  final CollectionReference fitnessLogCollection =
      FirebaseFirestore.instance.collection('fitness_logs');

  final CollectionReference periodLogCollection =
      FirebaseFirestore.instance.collection('period_logs');

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

  Future<void> createMealLog(
    String uid,
    DateTime date,
  ) async {
    await mealLogCollection.add({
      "uid": uid,
      "date": date,
      "ateBreakfast": false,
      "ateLunch": false,
      "ateDinner": false,
      "numSnacks": 0,
    });
  }

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
        .orderBy('date', descending: false)
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

  Future<void> createWaterLog(
    String uid,
    DateTime date,
  ) async {
    await waterLogCollection.add({
      "uid": uid,
      "date": date,
      "cupsDrank": 0.0,
      "numDaysOld": 0,
      "agedUp": false,
    });
  }

  Future<void> updateWaterLogData(
    String uid,
    DateTime date, {
    double numCupsAdd = 0,
  }) async {
    List<dynamic> waterLogInfo = await getWaterLog(uid, date);
    WaterLog currWaterLog = waterLogInfo[0];
    String docId = waterLogInfo[1];

    return await waterLogCollection.doc(docId).set({
      'uid': uid,
      'date': currWaterLog.date,
      'cupsDrank': currWaterLog.cupsDrank + numCupsAdd,
      'numDaysOld':
          ((!currWaterLog.agedUp && currWaterLog.cupsDrank + numCupsAdd >= 8))
              ? currWaterLog.numDaysOld + 1
              : currWaterLog.numDaysOld,
      'agedUp': currWaterLog.cupsDrank + numCupsAdd >= 8 ? true : false
    });
  }

  WaterLog _waterLogFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return WaterLog.fromData(data ?? {});
  }

  Stream<List<WaterLog>> get waterLog {
    return waterLogCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          return _waterLogFromSnapshot(doc);
        }).toList();
      } else {
        return [
          WaterLog(
            uid: uid,
            date: DateTime.now(),
          )
        ];
      }
    });
  }

  Future<List<dynamic>> getWaterLog(String uid, DateTime date) async {
    List<DateTime> dayRange = getDayRange(date);

    QuerySnapshot querySnapshot = await waterLogCollection
        .where('uid', isEqualTo: uid)
        .where('date', isLessThanOrEqualTo: dayRange[1])
        .where('date', isGreaterThanOrEqualTo: dayRange[0])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return [WaterLog.fromData(data), documentSnapshot.id];
    } else {
      throw Exception('No water log found');
    }
  }

  // FitnessLogs

  Future<void> createFitnessLog(
    String uid,
    DateTime date,
  ) async {
    await fitnessLogCollection.add({
      "uid": uid,
      "date": date,
      "gymTime": 0.0,
      "walkTime": 0.0,
      "yogaTime": 0.0,
    });
  }

  Future<void> updateFitnessLogData(
    String uid,
    DateTime date, {
    double incGymTime = 0.0,
    double incWalkTime = 0.0,
    double incYogaTime = 0.0,
  }) async {
    List<dynamic> fitnessLogInfo = await getFitnessLog(uid, date);
    FitnessLog currFitnessLog = fitnessLogInfo[0];
    String docId = fitnessLogInfo[1];

    return await fitnessLogCollection.doc(docId).set({
      'uid': uid,
      'date': currFitnessLog.date,
      'gymTime': currFitnessLog.gymTime + incGymTime,
      'walkTime': currFitnessLog.walkTime + incWalkTime,
      'yogaTime': currFitnessLog.yogaTime + incYogaTime
    });
  }

  FitnessLog _fitnessLogFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return FitnessLog.fromData(data ?? {});
  }

  Stream<List<FitnessLog>> get fitnessLog {
    return fitnessLogCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          return _fitnessLogFromSnapshot(doc);
        }).toList();
      } else {
        return [
          FitnessLog(
            uid: uid,
            date: DateTime.now(),
          )
        ];
      }
    });
  }

  Future<List<dynamic>> getFitnessLog(String uid, DateTime date) async {
    List<DateTime> dayRange = getDayRange(date);

    QuerySnapshot querySnapshot = await fitnessLogCollection
        .where('uid', isEqualTo: uid)
        .where('date', isLessThanOrEqualTo: dayRange[1])
        .where('date', isGreaterThanOrEqualTo: dayRange[0])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return [FitnessLog.fromData(data), documentSnapshot.id];
    } else {
      throw Exception('No fitness log found');
    }
  }

  // PeriodLogs

  Future<void> createPeriodLog(
    String uid,
    DateTime date,
  ) async {
    await periodLogCollection.add({
      "uid": uid,
      "date": date,
      "currently": false,
      "duration": 0,
    });
  }

  Future<void> updatePeriodLogData(
    String uid,
    DateTime date, {
    bool currently = false,
  }) async {
    List<dynamic> periodLogInfo = await getPeriodLog(uid, date);
    PeriodLog currPeriodLog = periodLogInfo[0];
    String docId = periodLogInfo[1];

    return await periodLogCollection.doc(docId).set({
      'uid': uid,
      'date': currPeriodLog.date,
      'currently': currPeriodLog.currently || currently,
      'duration': (currently && (currPeriodLog.currently != currently))
          ? currPeriodLog.duration + 1
          : currPeriodLog.duration,
    });
  }

  PeriodLog _periodLogFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return PeriodLog.fromData(data ?? {});
  }

  Stream<List<PeriodLog>> get periodLog {
    return periodLogCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          return _periodLogFromSnapshot(doc);
        }).toList();
      } else {
        return [
          PeriodLog(
            uid: uid,
            date: DateTime.now(),
          )
        ];
      }
    });
  }

  Future<List<dynamic>> getPeriodLog(String uid, DateTime date) async {
    List<DateTime> dayRange = getDayRange(date);

    QuerySnapshot querySnapshot = await periodLogCollection
        .where('uid', isEqualTo: uid)
        .where('date', isLessThanOrEqualTo: dayRange[1])
        .where('date', isGreaterThanOrEqualTo: dayRange[0])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      return [PeriodLog.fromData(data), documentSnapshot.id];
    } else {
      throw Exception('No period log found');
    }
  }
}
