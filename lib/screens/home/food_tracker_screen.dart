import 'package:flutter/material.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/services/database.dart';

class FoodTrackerScreen extends StatefulWidget {
  FoodTrackerScreen({Key? key, required MealLog mealLog, required String uid})
      : _mealLog = mealLog,
        _uid = uid,
        super(key: key);

  final MealLog _mealLog;
  final String _uid;

  @override
  State<FoodTrackerScreen> createState() => _FoodTrackerScreenState();
}

class _FoodTrackerScreenState extends State<FoodTrackerScreen> {
  late MealLog _mealLog;
  late String _uid;

  @override
  void initState() {
    _mealLog = widget._mealLog;
    _uid = widget._uid;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(children: [
          Text(
            "ateDinner: ${_mealLog?.ateDinner}\n ateLunch: ${_mealLog?.ateLunch}\n ateBreakfast: ${_mealLog?.ateBreakfast}\n",
          ),
          SizedBox(height: 30.0),
          TextButton(
              onPressed: () async => {
                    if (_mealLog?.ateLunch == false)
                      {
                        await DatabaseService().updateMealLogData(
                            _uid, DateTime.now(),
                            ateLunch: true)
                      }
                  },
              child: Text(
                "Toggle ateLunch: ${_mealLog?.ateLunch}",
              ))
        ]));
  }
}
