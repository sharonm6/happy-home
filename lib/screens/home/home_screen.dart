import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/screens/home/food_tracker_screen.dart';
import 'package:happy_home/screens/home/water_tracker_screen.dart';
import 'package:happy_home/screens/home/fitness_tracker_screen.dart';
import 'package:happy_home/screens/home/period_tracker_screen.dart';
import 'package:happy_home/services/auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required User user, required Function setNavBarIdx})
      : _user = user,
        setNavBarIdx = setNavBarIdx,
        super(key: key);

  final User _user;
  final Function setNavBarIdx;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  late User _user;
  late Function setNavBarIdx;

  @override
  void initState() {
    _user = widget._user;
    setNavBarIdx = widget.setNavBarIdx;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  constraints: BoxConstraints(maxWidth: 200),
                  icon: Image.asset('assets/home_food.jpeg'),
                  iconSize: 200,
                  onPressed: () {
                    setNavBarIdx(1);
                  }),
              IconButton(
                  constraints: BoxConstraints(maxWidth: 200),
                  icon: Image.asset('assets/home_period.jpeg'),
                  iconSize: 200,
                  onPressed: () {
                    setNavBarIdx(2);
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  constraints: BoxConstraints(maxWidth: 200),
                  icon: Image.asset('assets/home_water.jpeg'),
                  iconSize: 200,
                  onPressed: () {
                    setNavBarIdx(3);
                  }),
              IconButton(
                  constraints: BoxConstraints(maxWidth: 200),
                  icon: Image.asset('assets/home_fitness.jpeg'),
                  iconSize: 200,
                  onPressed: () {
                    setNavBarIdx(4);
                  }),
            ],
          )
        ]);
  }
}
