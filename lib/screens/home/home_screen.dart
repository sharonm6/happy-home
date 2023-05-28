import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';
import 'package:happy_home/components/rounded_rectangle.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/screens/home/food_tracker_screen.dart';
import 'package:happy_home/screens/home/water_tracker_screen.dart';
import 'package:happy_home/screens/home/fitness_tracker_screen.dart';
import 'package:happy_home/screens/home/period_tracker_screen.dart';
import 'package:happy_home/services/auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  late User _user;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Home Page ${_user.name}\n",
      ),
      PeriodTrackerScreen(uid: _user.uid),
      FitnessTrackerScreen(uid: _user.uid),
      WaterTrackerScreen(uid: _user.uid),
      FoodTrackerScreen(uid: _user.uid),
      TextButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(
            'Logout',
          ),
        ),
        onPressed: () async {
          await _auth.signOut();
        },
      ),
    ]);
  }
}
