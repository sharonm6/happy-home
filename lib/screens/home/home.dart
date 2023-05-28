import 'package:flutter/material.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/config/color_constants.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/screens/home/fitness_tracker_screen.dart';
import 'package:happy_home/screens/home/food_tracker_screen.dart';
import 'package:happy_home/screens/home/home_screen.dart';
import 'package:happy_home/screens/home/period_tracker_screen.dart';
import 'package:happy_home/screens/home/water_tracker_screen.dart';
import 'package:happy_home/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:happy_home/models/user.dart';
import 'package:happy_home/services/database.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.user, required this.databaseService});
  final User user;
  final DatabaseService databaseService;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int navBarIdx = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: widget.databaseService.user,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            User userInfo = userSnapshot.data!;
            List<Widget> pages = [
              HomeScreen(user: userInfo),
              FoodTrackerScreen(uid: userInfo.uid),
              PeriodTrackerScreen(uid: userInfo.uid),
              WaterTrackerScreen(uid: userInfo.uid),
              FitnessTrackerScreen(uid: userInfo.uid)
            ];
            List<String> titles = [
              "Happy Home",
              "Food Tracker",
              "Period Tracker",
              "Water Tracker",
              "Fitness Tracker"
            ];

            return Scaffold(
                appBar: AppBar(
                  title: Text(titles[navBarIdx]),
                  backgroundColor: ColorConstants.happyhomeBrown,
                  elevation: 0.0,
                  actions: <Widget>[
                    TextButton(
                      child: Icon(Icons.home),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          navBarIdx = 0;
                        });
                      },
                    ),
                    TextButton(
                      child: Icon(Icons.exit_to_app),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    ),
                    // TextButton(
                    //   child: Icon(Icons.calendar_month_outlined),
                    //   style:
                    //       TextButton.styleFrom(foregroundColor: Colors.white),
                    //   onPressed: () => {},
                    // )
                  ],
                ),
                body: SingleChildScrollView(child: pages[navBarIdx]));
          } else {
            return Scaffold(
              body: SizedBox(height: 20.0),
            );
          }
        });
  }
}
