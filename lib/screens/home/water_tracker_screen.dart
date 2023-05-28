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
    return StreamBuilder<List<WaterLog>>(
        stream: databaseService.waterLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<WaterLog> waterInfos = mealSnapshot.data!;
            WaterLog _waterLog = waterInfos[0];

            return Column(children: [
              Text('Water Tracker', style: TextStyle(fontSize: 30)),
              ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.brown[400],
                ),
                title: Text(_waterLog.date.toString()),
                subtitle: Text(
                  '${_waterLog.uid} uid\n'
                  '${_waterLog.date} date\n'
                  '${_waterLog.cupsDrank} cups drank\n'
                  '${_waterLog.numDaysOld} numDaysOld\n'
                  '${_waterLog.agedUp} agedUp\n',
                ),
              ),
              TextButton(
                  onPressed: () async => {
                        await DatabaseService().updateWaterLogData(
                            widget._uid, DateTime.now(),
                            numCupsAdd: 1)
                      },
                  child: Text(
                    "Toggle cupsDrank: ${_waterLog?.cupsDrank}",
                  )),
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
