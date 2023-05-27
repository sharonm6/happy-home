import 'package:flutter/material.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/screens/home/meal_tile.dart';
import 'package:happy_home/services/database.dart';

class FoodTrackerScreen extends StatefulWidget {
  FoodTrackerScreen(
      {Key? key, required List<MealLog> mealLogs, required String uid})
      : _mealLogs = mealLogs,
        _uid = uid,
        super(key: key);

  final List<MealLog> _mealLogs;
  final String _uid;

  @override
  State<FoodTrackerScreen> createState() => _FoodTrackerScreenState();
}

class _FoodTrackerScreenState extends State<FoodTrackerScreen> {
  late List<MealLog> _mealLogs;
  late String _uid;

  @override
  void initState() {
    _mealLogs = widget._mealLogs;
    _uid = widget._uid;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealLog _mealLog = _mealLogs[0];

    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              "ateDinner: ${_mealLog?.ateDinner}\n ateLunch: ${_mealLog?.ateLunch}\n ateBreakfast: ${_mealLog?.ateBreakfast}\n",
            ),
            SizedBox(height: 30.0),
            TextButton(
                onPressed: () async => {
                      await DatabaseService().updateMealLogData(
                          _uid, DateTime.now(),
                          ateBreakfast: true)
                    },
                child: Text(
                  "Toggle ateBreakfast: ${_mealLog?.ateBreakfast}",
                )),
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: _mealLogs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        MealTile(mealLog: _mealLogs[index]),
                        SizedBox(height: 50.0),
                      ],
                    );
                  },
                ))
          ],
        ));
  }
}
