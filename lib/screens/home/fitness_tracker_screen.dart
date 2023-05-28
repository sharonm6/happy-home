import 'package:flutter/material.dart';
import 'package:happy_home/models/fitness_log.dart';
import 'package:happy_home/services/database.dart';
import 'package:pie_chart/pie_chart.dart';

class FitnessTrackerScreen extends StatefulWidget {
  FitnessTrackerScreen({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  State<FitnessTrackerScreen> createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  late final DatabaseService databaseService;

  @override
  void initState() {
    databaseService = DatabaseService(uid: widget._uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FitnessLog>>(
        stream: databaseService.fitnessLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<FitnessLog> fitnessInfos = mealSnapshot.data!;
            FitnessLog _fitnessLog = fitnessInfos[0];

            return Column(children: [
              SizedBox(height: 16),
              PieChart(
                dataMap: {
                  "Gym": _fitnessLog.gymTime,
                  "Walk": _fitnessLog.walkTime,
                  "Yoga": _fitnessLog.yogaTime,
                  "N/A": 24 -
                      (_fitnessLog.gymTime +
                          _fitnessLog.walkTime +
                          _fitnessLog.yogaTime),
                },
                legendOptions: LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                ),
                chartRadius: MediaQuery.of(context).size.width / 1.5,
                colorList: [
                  Colors.blue[300]!,
                  Colors.orange[300]!,
                  Colors.purple[300]!,
                  Colors.grey[300]!,
                ],
                baseChartColor: Colors.grey[300]!,
              ),
              SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(children: [
                  IconButton(
                    icon: Image.asset('assets/fitness_gym.png'),
                    iconSize: 140,
                    onPressed: () async => {
                      await DatabaseService().updateFitnessLogData(
                          _fitnessLog.uid, DateTime.now(),
                          incGymTime: .5)
                    },
                  ),
                  Text("Gym (+30min)", style: TextStyle(fontSize: 18)),
                ]),
                Column(children: [
                  IconButton(
                    icon: Image.asset('assets/fitness_walk.png'),
                    iconSize: 140,
                    onPressed: () async => {
                      await DatabaseService().updateFitnessLogData(
                          _fitnessLog.uid, DateTime.now(),
                          incWalkTime: .5)
                    },
                  ),
                  Text("Walk (+30min)", style: TextStyle(fontSize: 18)),
                ]),
                Column(children: [
                  IconButton(
                    icon: Image.asset('assets/fitness_yoga.png'),
                    iconSize: 140,
                    onPressed: () async => {
                      await DatabaseService().updateFitnessLogData(
                          _fitnessLog.uid, DateTime.now(),
                          incYogaTime: .5)
                    },
                  ),
                  Text("Yoga (+30min)", style: TextStyle(fontSize: 18)),
                ]),
              ])
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
