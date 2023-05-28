import 'package:flutter/material.dart';
import 'package:happy_home/models/water_log.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/services/database.dart';

class WaterTrackerScreen extends StatefulWidget {
  WaterTrackerScreen({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  late final DatabaseService databaseService;

  @override
  void initState() {
    databaseService = DatabaseService(uid: widget._uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? waterPotImg;

    return StreamBuilder<List<WaterLog>>(
        stream: databaseService.waterLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<WaterLog> waterInfos = mealSnapshot.data!;
            WaterLog _waterLog = waterInfos[0];

            if (_waterLog.cupsDrank >= 8) {
              waterPotImg = "assets/water_pot_8.png";
            } else if (_waterLog.cupsDrank >= 7) {
              waterPotImg = "assets/water_pot_7.png";
            } else if (_waterLog.cupsDrank >= 6) {
              waterPotImg = "assets/water_pot_6.png";
            } else if (_waterLog.cupsDrank >= 5) {
              waterPotImg = "assets/water_pot_5.png";
            } else if (_waterLog.cupsDrank >= 4) {
              waterPotImg = "assets/water_pot_4.png";
            } else if (_waterLog.cupsDrank >= 3) {
              waterPotImg = "assets/water_pot_3.png";
            } else if (_waterLog.cupsDrank >= 2) {
              waterPotImg = "assets/water_pot_2.png";
            } else if (_waterLog.cupsDrank >= 1) {
              waterPotImg = "assets/water_pot_1.png";
            } else {
              waterPotImg = "assets/water_pot_0.png";
            }

            return Column(children: [
              SizedBox(height: 8),
              Center(
                child: Text(
                  "${_waterLog.numDaysOld} Day(s) Old",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 8),
              Image.asset(waterPotImg ?? 'assets/water_pot_0.png', height: 500),
              SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(children: [
                  IconButton(
                    icon: Image.asset('assets/water_cup_half.png'),
                    iconSize: 100,
                    onPressed: () async => {
                      await DatabaseService().updateWaterLogData(
                          _waterLog.uid, DateTime.now(),
                          numCupsAdd: 0.5)
                    },
                  ),
                  Text("Drank 1/2 cup", style: TextStyle(fontSize: 18)),
                ]),
                Column(children: [
                  IconButton(
                    icon: Image.asset('assets/water_cup_full.png'),
                    iconSize: 100,
                    onPressed: () async => {
                      await DatabaseService().updateWaterLogData(
                          _waterLog.uid, DateTime.now(),
                          numCupsAdd: 1)
                    },
                  ),
                  Text("Drank 1 cup", style: TextStyle(fontSize: 18)),
                ]),
              ])
              // TextButton(
              //     onPressed: () async => {
              //           await DatabaseService().updateWaterLogData(
              //               _waterLog.uid, DateTime.now(),
              //               numCupsAdd: 1)
              //         },
              //     child: Text(
              //       "Toggle cupsDrank: ${_waterLog?.cupsDrank}",
              //     )),
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
