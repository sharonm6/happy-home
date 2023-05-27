import 'package:flutter/material.dart';
import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/screens/home/meal_tile.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/services/database.dart';

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
    return StreamBuilder<List<MealLog>>(
        stream: databaseService.mealLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<MealLog> mealInfos = mealSnapshot.data!;
            return Padding(
                padding: const EdgeInsets.all(30),
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: mealInfos.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MealTile(
                                mealLog: mealInfos[index], uid: widget._uid),
                            SizedBox(height: 50.0),
                          ],
                        );
                      },
                    )));
          } else {
            return SizedBox(height: 40.0);
          }
        });
  }
}
