import 'package:flutter/material.dart';
import 'package:happy_home/models/meal_log.dart';

class MealTile extends StatefulWidget {
  const MealTile({Key? key, required MealLog mealLog})
      : _mealLog = mealLog,
        super(key: key);

  final MealLog _mealLog;

  @override
  State<MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<MealTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
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
      ),
    );
  }
}
