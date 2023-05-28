import 'package:flutter/material.dart';
import 'package:happy_home/models/fitness_log.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/services/database.dart';

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
              ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.brown[400],
                ),
                title: Text(_fitnessLog.date.toString()),
                subtitle: Text(
                  '${_fitnessLog.uid} uid\n'
                  '${_fitnessLog.date} date\n'
                  '${_fitnessLog.gymTime} hours of gym\n'
                  '${_fitnessLog.walkTime} hours of walking\n'
                  '${_fitnessLog.yogaTime} hours of yoga\n',
                ),
              ),
              TextButton(
                  onPressed: () async => {
                        await DatabaseService().updateFitnessLogData(
                            widget._uid, DateTime.now(),
                            incGymTime: 2)
                      },
                  child: Text(
                    "Toggle gym time: ${_fitnessLog?.gymTime}",
                  )),
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
