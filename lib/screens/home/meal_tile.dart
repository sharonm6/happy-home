import 'package:flutter/material.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/services/database.dart';

class MealTile extends StatefulWidget {
  const MealTile({Key? key, required MealLog mealLog, required String? uid})
      : _mealLog = mealLog,
        _uid = uid ?? '',
        super(key: key);

  final MealLog _mealLog;
  final String _uid;

  @override
  State<MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<MealTile> {
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
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: Column(children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.brown[400],
                ),
                title: Text(widget._mealLog.date.toString()),
                subtitle: Text('${widget._mealLog.ateBreakfast} breakfast\n'
                    '${widget._mealLog.ateLunch} lunch\n'
                    '${widget._mealLog.ateDinner} dinner\n'
                    '${widget._mealLog.numSnacks} snacks\n'),
              ),
              TextButton(
                  onPressed: () async => {
                        await DatabaseService().updateMealLogData(
                            _uid, DateTime.now(),
                            ateBreakfast: true)
                      },
                  child: Text(
                    "Toggle ateBreakfast: ${_mealLog?.ateBreakfast}",
                  )),
            ])));
  }
}
