import 'package:flutter/material.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/services/database.dart';
import 'package:happy_home/screens/home/food_calendar.dart';

class FoodTrackerScreen extends StatefulWidget {
  FoodTrackerScreen({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  State<FoodTrackerScreen> createState() => _FoodTrackerScreenState();
}

class _FoodTrackerScreenState extends State<FoodTrackerScreen> {
  late final DatabaseService databaseService;

  @override
  void initState() {
    databaseService = DatabaseService(uid: widget._uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? mealTableImg;

    return StreamBuilder<List<MealLog>>(
        stream: databaseService.mealLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<MealLog> mealInfos = mealSnapshot.data!;
            MealLog mealLog = mealInfos[mealInfos.length - 1];

            if (!mealLog.ateBreakfast &&
                !mealLog.ateLunch &&
                !mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_000.png";
            } else if (mealLog.ateBreakfast &&
                !mealLog.ateLunch &&
                !mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_100.png";
            } else if (!mealLog.ateBreakfast &&
                mealLog.ateLunch &&
                !mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_010.png";
            } else if (!mealLog.ateBreakfast &&
                !mealLog.ateLunch &&
                mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_001.png";
            } else if (mealLog.ateBreakfast &&
                mealLog.ateLunch &&
                !mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_110.png";
            } else if (mealLog.ateBreakfast &&
                !mealLog.ateLunch &&
                mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_101.png";
            } else if (!mealLog.ateBreakfast &&
                mealLog.ateLunch &&
                mealLog.ateDinner) {
              mealTableImg = "assets/meal_table_011.png";
            } else {
              mealTableImg = "assets/meal_table_111.png";
            }

            return Column(children: [
              FoodCalendar(uid: widget._uid, mealLogs: mealInfos),
              ElevatedButton(
                onPressed: () async => {
                  await DatabaseService().updateMealLogData(
                      widget._uid, DateTime.now(),
                      addSnack: true)
                },
                child: Text('Ate a\nSnack',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    )),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(35),
                  backgroundColor: Colors.blue, // <-- Button color
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async => {
                          await DatabaseService().updateMealLogData(
                              widget._uid, DateTime.now(),
                              ateBreakfast: true)
                        },
                        child: Text('Ate\nBreakfast',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(35),
                          backgroundColor: Colors.blue, // <-- Button color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async => {
                          await DatabaseService().updateMealLogData(
                              widget._uid, DateTime.now(),
                              ateLunch: true)
                        },
                        child: Text('Ate\nLunch',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(35),
                          backgroundColor: Colors.blue, // <-- Button color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async => {
                          await DatabaseService().updateMealLogData(
                              widget._uid, DateTime.now(),
                              ateDinner: true)
                        },
                        child: Text('Ate\nDinner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(35),
                          backgroundColor: Colors.blue, // <-- Button color
                        ),
                      ),
                    ]),
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  mealTableImg ?? 'assets/meal_table_000.png',
                ),
              ),
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
