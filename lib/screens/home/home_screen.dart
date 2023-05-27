import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';
import 'package:happy_home/components/rounded_rectangle.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/screens/home/food_tracker_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required User user, required MealLog mealLog})
      : _user = user,
        _mealLog = mealLog,
        super(key: key);

  final User _user;
  final MealLog _mealLog;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  late MealLog _mealLog;

  @override
  void initState() {
    _user = widget._user;
    _mealLog = widget._mealLog;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(children: [
        Text(
          "Home Page ${_user.name}\n",
        ),
        FoodTrackerScreen(mealLog: _mealLog, uid: _user.uid),
      ]),
    );
  }
}
